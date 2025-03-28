import 'package:get/get.dart';
import 'package:healty_ways/model/appointment_model.dart';

class AppointmentViewModel extends GetxController {
  final RxList<AppointmentModel> _appointments = <AppointmentModel>[].obs;
  List<AppointmentModel> get appointments => _appointments;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _appointments.addAll([
      AppointmentModel(
        doctorId: 'doctor1',
        patientId: 'patient1',
        time: DateTime.now().add(const Duration(days: 1)),
        status: AppointmentStatus.upcoming,
      ),
      AppointmentModel(
        doctorId: 'doctor1',
        patientId: 'patient2',
        time: DateTime.now().add(const Duration(days: 2)),
        status: AppointmentStatus.upcoming,
      ),
    ]);
  }

  void addAppointment(AppointmentModel appointment) {
    _appointments.add(appointment);
  }

  void cancelAppointment(String doctorId, String patientId, DateTime time) {
    _appointments.removeWhere((appt) =>
        appt.doctorId == doctorId &&
        appt.patientId == patientId &&
        appt.time == time);
  }

  void updateAppointmentStatus(String doctorId, String patientId, DateTime time,
      AppointmentStatus status) {
    final appointment = _appointments.firstWhere((appt) =>
        appt.doctorId == doctorId &&
        appt.patientId == patientId &&
        appt.time == time);
    appointment.status = status;
    _appointments.refresh();
  }

  List<AppointmentModel> getAppointmentsForPatient(String patientId) {
    return _appointments.where((appt) => appt.patientId == patientId).toList();
  }

  List<AppointmentModel> getAppointmentsForDoctor(String doctorId) {
    return _appointments.where((appt) => appt.doctorId == doctorId).toList();
  }
}
