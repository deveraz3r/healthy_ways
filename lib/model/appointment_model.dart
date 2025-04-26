import 'package:healty_ways/utils/app_urls.dart';

enum AppointmentStatus { upcoming, inProgress, completed, missed }

extension AppointmentStatusExtension on AppointmentStatus {
  String get value => toString().split('.').last;
}

class AppointmentModel {
  String appointmentId;
  final String doctorId;
  final String patientId;
  final DateTime time;
  AppointmentStatus status;
  final String? report;
  String? chatId;

  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.time,
    required this.status,
    this.report,
    this.chatId,
  });

  Map<String, dynamic> toJson() => {
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'patientId': patientId,
        'time': time.toIso8601String(),
        'status': status.value,
        'report': report,
        'chatId': chatId,
      };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        appointmentId: json['appointmentId'],
        doctorId: json['doctorId'],
        patientId: json['patientId'],
        time: DateTime.parse(json['time']),
        status: AppointmentStatus.values.firstWhere(
            (e) => e.value == json['status'],
            orElse: () => AppointmentStatus.upcoming),
        report: json['report'],
        chatId: json['chatId'],
      );

  AppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? patientId,
    DateTime? time,
    AppointmentStatus? status,
    String? report,
    String? chatId,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      time: time ?? this.time,
      status: status ?? this.status,
      report: report ?? this.report,
      chatId: chatId ?? this.chatId,
    );
  }
}
