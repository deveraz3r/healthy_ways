enum AppointmentState {
  upcoming,
  missed,
  completed,
}

class Appointment {
  final String patientEmail;
  final String doctorEmail;
  final DateTime time;
  final AppointmentState state;
  final int appointmentId;
  final String qualification;
  final String specality;
  final String? profilePhoto;

  Appointment({
    required this.patientEmail,
    required this.doctorEmail,
    required this.time,
    required this.state,
    required this.appointmentId,
    required this.qualification,
    required this.specality,
    this.profilePhoto,
  });
}
