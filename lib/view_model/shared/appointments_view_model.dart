import 'package:get/get.dart';
import 'package:healty_ways/model/shared/appointment.dart';

class AppointmentViewModel extends GetxController {
  // List of appointments (reactive)
  final RxList<Appointment> appointments = <Appointment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load appointments when the ViewModel is initialized
    _loadAppointments();
  }

  // Simulate loading appointments (replace with API call in a real app)
  void _loadAppointments() {
    final List<Appointment> loadedAppointments = [
      Appointment(
        patientEmail: 'patient1@example.com',
        doctorEmail: 'doctor1@example.com',
        time: DateTime(2023, 10, 15, 10, 0), // October 15, 2023, 10:00 AM
        state: AppointmentState.completed,
        appointmentId: 1,
        profilePhoto: null,
        specality: "PHD",
        qualification: 'Cardiologist', // Example qualification
      ),
      Appointment(
        patientEmail: 'patient1@example.com',
        doctorEmail: 'doctor2@example.com',
        time: DateTime(2023, 10, 15, 14, 0), // OctoberS 15, 2023, 2:00 PM
        state: AppointmentState.missed,
        appointmentId: 2,
        profilePhoto: null,
        specality: "MBBS",
        qualification: 'General Physician', // Example qualification
      ),
      Appointment(
        patientEmail: 'patient1@example.com',
        doctorEmail: 'doctor3@example.com',
        time: DateTime(2023, 10, 16, 9, 0), // October 16, 2023, 9:00 AM
        state: AppointmentState.upcoming,
        appointmentId: 3,
        profilePhoto: null,
        specality: "MBBS",
        qualification: 'Neurologist', // Example qualification
      ),
      // Add more appointments here...
    ];

    appointments.assignAll(loadedAppointments); // Update the reactive list
  }

  // Get appointments grouped by date
  Map<DateTime, List<Appointment>> getAppointmentsByDate() {
    final Map<DateTime, List<Appointment>> groupedAppointments = {};

    for (final appointment in appointments) {
      final date = DateTime(
          appointment.time.year, appointment.time.month, appointment.time.day);
      if (!groupedAppointments.containsKey(date)) {
        groupedAppointments[date] = [];
      }
      groupedAppointments[date]!.add(appointment);
    }

    return groupedAppointments;
  }
}
