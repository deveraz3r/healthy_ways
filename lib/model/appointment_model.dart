enum AppointmentStatus { upcoming, inProgress, completed, missed }

extension AppointmentStatusExtension on AppointmentStatus {
  String get value => toString().split('.').last;
}

class AppointmentModel {
  final String doctorId;
  final String patientId;
  final DateTime time;
  AppointmentStatus status;
  final String? report;

  AppointmentModel({
    required this.doctorId,
    required this.patientId,
    required this.time,
    required this.status,
    this.report,
  });

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'patientId': patientId,
        'time': time.toIso8601String(),
        'status': status.value,
        'report': report,
      };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        doctorId: json['doctorId'],
        patientId: json['patientId'],
        time: DateTime.parse(json['time']),
        status: AppointmentStatus.values.firstWhere(
            (e) => e.value == json['status'],
            orElse: () => AppointmentStatus.upcoming),
        report: json['report'],
      );

  AppointmentModel copyWith({
    String? doctorId,
    String? patientId,
    DateTime? time,
    AppointmentStatus? status,
  }) {
    return AppointmentModel(
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}
