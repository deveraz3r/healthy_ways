import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/model/doctor_model.dart';

class AppointmentsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AppointmentModel> _appointments = <AppointmentModel>[].obs;
  final RxMap<String, DoctorModel> _doctorCache = <String, DoctorModel>{}.obs;

  List<AppointmentModel> get appointments => _appointments;

  Future<void> fetchUserAppointments(String userId, bool isDoctor) async {
    try {
      final field = isDoctor ? 'doctorId' : 'patientId';
      final query = await _firestore
          .collection('appointments')
          .where(field, isEqualTo: userId)
          .orderBy('time')
          .get();

      // Clear previous data
      _appointments.clear();
      _doctorCache.clear();

      // Process appointments
      for (final doc in query.docs) {
        final appointment = AppointmentModel.fromJson(doc.data());
        _appointments.add(appointment);

        // Fetch doctor info if not already cached
        if (!_doctorCache.containsKey(appointment.doctorId)) {
          final doctorDoc = await _firestore
              .collection('doctors')
              .doc(appointment.doctorId)
              .get();

          if (doctorDoc.exists) {
            _doctorCache[appointment.doctorId] =
                DoctorModel.fromJson(doctorDoc.data()!);
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch appointments: ${e.toString()}");
    }
  }

  DoctorModel? getDoctorInfo(String doctorId) {
    return _doctorCache[doctorId];
  }

  Map<DateTime, List<AppointmentModel>> getAppointmentsByDate() {
    final grouped = <DateTime, List<AppointmentModel>>{};

    for (final appointment in _appointments) {
      final date = DateTime(
        appointment.time.year,
        appointment.time.month,
        appointment.time.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(appointment);
    }

    return grouped;
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      await _firestore.collection('appointments').add(appointment.toJson());
      _appointments.add(appointment);
    } catch (e) {
      Get.snackbar("Error", "Failed to book appointment: ${e.toString()}");
    }
  }
}
