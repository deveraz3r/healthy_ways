import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'assigned_medication_view_model.dart';

class AppointmentsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;

  final RxBool isInitial = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  Future<void> fetchUserAppointments(String userId, bool isDoctor) async {
    try {
      final field = isDoctor ? 'doctorId' : 'patientId';

      final query = await _firestore
          .collection('appointments')
          .where(field, isEqualTo: userId)
          .get();

      // Clear previous data
      appointments.clear();

      List<AppointmentModel> fetchedAppointments = [];

      for (final doc in query.docs) {
        final data = doc.data();

        final appointment = AppointmentModel.fromJson(data);
        fetchedAppointments.add(appointment);
      }

      //TODO: move sorting logic to firebase server
      // Sort appointments by time
      fetchedAppointments.sort((a, b) => a.time.compareTo(b.time));

      // Update the observable list
      appointments.assignAll(fetchedAppointments);
      isInitial.value = false;

      await processingUpdates();
    } catch (e) {
      _handleError("Failed to fetch appointments", e);
    }
  }

  Map<DateTime, List<AppointmentModel>> getAppointmentsByDate() {
    try {
      final grouped = <DateTime, List<AppointmentModel>>{};

      for (final appointment in appointments) {
        final date = DateTime(
          appointment.time.year,
          appointment.time.month,
          appointment.time.day,
        );

        grouped.putIfAbsent(date, () => []);
        grouped[date]!.add(appointment);
      }

      // Sort each list of appointments by time in descending order
      grouped.forEach((key, list) {
        list.sort((a, b) => b.time.compareTo(a.time));
      });

      final sortedMap = Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
      );

      return sortedMap;
    } catch (e) {
      _handleError("Failed to group appointments by date", e);
      return {};
    }
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      final docRef = _firestore.collection('appointments').doc();
      appointment.appointmentId = docRef.id; // Assign unique Firestore doc ID

      await docRef.set(appointment.toJson()); // Save to Firestore
      appointments.add(appointment); // Add to local list
    } catch (e) {
      _handleError("Failed to book appointment", e);
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

      final index = appointments.indexWhere(
        (a) => a.appointmentId == appointment.appointmentId,
      );

      if (index != -1) {
        appointments[index] = appointments[index].copyWith(status: newStatus);
      }
    } catch (e) {
      _handleError("Failed to update appointment status", e);
    }
  }

  Future<void> processingUpdates() async {
    try {
      //TODO: Move this logic firebase server
      //TODO: Implement logic to check for missed or completed appointments
      for (var appointment in appointments) {
        final now = DateTime.now();
        final timeDiff = now.difference(appointment.time).inMinutes;

        if (appointment.status == AppointmentStatus.upcoming && timeDiff > 30) {
          await updateAppointmentStatus(appointment, AppointmentStatus.missed);
        }

        if (appointment.status == AppointmentStatus.inProgress &&
            timeDiff > 30) {
          await updateAppointmentStatus(
              appointment, AppointmentStatus.completed);
        }
      }
    } catch (e) {
      _handleError("Failed to process updates", e);
    }
  }

  Future<void> completeAppointmentWithReport(String appointmentId) async {
    try {
      final report =
          Get.find<AssignedMedicationViewModel>().generateMedicationReport();

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': AppointmentStatus.completed.value,
        'report': report,
      });

      final index = appointments.indexWhere(
        (a) => a.appointmentId == appointmentId,
      );
      if (index != -1) {
        appointments[index] = appointments[index].copyWith(
          status: AppointmentStatus.completed,
          report: report,
        );
      }
    } catch (e) {
      _handleError("Failed to complete appointment with report", e);
    }
  }

  Future<void> saveChatId(String appointmentId, String chatId) async {
    try {
      final index = appointments.indexWhere(
        (e) => e.appointmentId == appointmentId,
      );
      if (index == -1) return;

      // Update Firestore
      await _firestore.collection('appointments').doc(appointmentId).update({
        'chatId': chatId,
      });

      // Update locally
      appointments[index] = appointments[index].copyWith(chatId: chatId);
      appointments.refresh();
    } catch (e) {
      _handleError("Failed to save chat ID", e);
    }
  }

  _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
