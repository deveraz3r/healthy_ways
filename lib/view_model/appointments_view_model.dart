import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'assigned_medication_view_model.dart';

class AppointmentsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AppointmentModel> _appointments = <AppointmentModel>[].obs;
  final RxMap<String, DoctorModel> _doctorCache = <String, DoctorModel>{}.obs;
  final RxMap<String, PatientModel> _patientCache =
      <String, PatientModel>{}.obs;

  final RxBool isInitial = true.obs;

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  List<AppointmentModel> get appointments => _appointments;
  ProfileViewModel get profileVM => _profileVM;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUserAppointments(String userId, bool isDoctor) async {
    try {
      final field = isDoctor ? 'doctorId' : 'patientId';

      final query = await _firestore
          .collection('appointments')
          .where(field, isEqualTo: userId)
          .get();

      // Clear previous data
      _appointments.clear();
      _doctorCache.clear();
      _patientCache.clear();

      List<AppointmentModel> fetchedAppointments = [];

      for (final doc in query.docs) {
        final data = doc.data();
        data['appointmentId'] = doc.id; // Attach the Firestore doc ID

        final appointment = AppointmentModel.fromJson(data);
        fetchedAppointments.add(appointment);

        // Fetch doctor info if not already cached
        if (!_doctorCache.containsKey(appointment.doctorId)) {
          final doctorDoc = await _firestore
              .collection('users')
              .doc(appointment.doctorId)
              .get();

          if (doctorDoc.exists) {
            _doctorCache[appointment.doctorId] =
                DoctorModel.fromJson(doctorDoc.data()!);
          }
        }

        // Fetch patient info if not already cached
        if (!_patientCache.containsKey(appointment.patientId)) {
          final patientDoc = await _firestore
              .collection('users')
              .doc(appointment.patientId)
              .get();

          if (patientDoc.exists) {
            _patientCache[appointment.patientId] =
                PatientModel.fromJson(patientDoc.data()!);
          }
        }
      }

      // Sort appointments by time
      fetchedAppointments.sort((a, b) => a.time.compareTo(b.time));

      // Update the observable list
      _appointments.assignAll(fetchedAppointments);
      isInitial.value = false;

      await processingUpdates();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch appointments: ${e.toString()}");
    }
  }

  DoctorModel? getDoctorInfo(String doctorId) {
    return _doctorCache[doctorId];
  }

  PatientModel? getPatientInfo(String patientId) {
    return _patientCache[patientId];
  }

  Map<DateTime, List<AppointmentModel>> getAppointmentsByDate() {
    final grouped = <DateTime, List<AppointmentModel>>{};

    for (final appointment in _appointments) {
      final date = DateTime(
        appointment.time.year,
        appointment.time.month,
        appointment.time.day,
      );

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(appointment);
    }

    grouped.forEach((key, list) {
      list.sort((a, b) => b.time.compareTo(a.time));
    });

    final sortedMap = Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));

    return sortedMap;
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      final docRef = _firestore.collection('appointments').doc();
      appointment.appointmentId = docRef.id;

      await docRef.set(appointment.toJson());
      _appointments.add(appointment);
    } catch (e) {
      Get.snackbar("Error", "Failed to book appointment: ${e.toString()}");
    }
  }

  Future<void> updateAppointmentStatus(
    AppointmentModel appointment,
    AppointmentStatus newStatus,
  ) async {
    try {
      final docRef =
          _firestore.collection('appointments').doc(appointment.appointmentId);

      await docRef.update({'status': newStatus.value});

      final index = _appointments.indexWhere(
        (a) => a.appointmentId == appointment.appointmentId,
      );

      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: newStatus);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update appointment status");
    }
  }

  Future<void> processingUpdates() async {
    for (var appointment in _appointments) {
      final now = DateTime.now();
      final timeDiff = now.difference(appointment.time).inMinutes;

      if (appointment.status == AppointmentStatus.upcoming && timeDiff > 30) {
        await updateAppointmentStatus(appointment, AppointmentStatus.missed);
      }

      if (appointment.status == AppointmentStatus.inProgress && timeDiff > 30) {
        await updateAppointmentStatus(appointment, AppointmentStatus.completed);
      }
    }
  }

  Future<void> completeAppointmentWithReport(String appointmentId) async {
    final report =
        Get.find<AssignedMedicationViewModel>().generateMedicationReport();

    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': AppointmentStatus.completed.value,
      'report': report,
    });

    final index =
        _appointments.indexWhere((a) => a.appointmentId == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.completed,
      );
    }
  }
}
