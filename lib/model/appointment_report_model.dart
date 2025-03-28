import 'package:healty_ways/model/medication_model.dart';

class AppointmentReportModel {
  final String doctorId;
  final String patientId;
  final String patientName;
  final String disease;
  final List<MedicationModel> medications;

  AppointmentReportModel({
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.disease,
    List<MedicationModel>? medications,
  }) : medications = medications ?? [];

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'disease': disease,
        'medications': medications.map((m) => m.toJson()).toList(),
      };

  factory AppointmentReportModel.fromJson(Map<String, dynamic> json) =>
      AppointmentReportModel(
        doctorId: json['doctorId'],
        patientId: json['patientId'],
        patientName: json['patientName'],
        disease: json['disease'],
        medications: (json['medications'] as List<dynamic>?)
                ?.map((m) => MedicationModel.fromJson(m))
                .toList() ??
            [],
      );
}
