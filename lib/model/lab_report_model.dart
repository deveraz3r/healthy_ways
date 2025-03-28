enum LabReportStatus { assigned, inProgress, completed, canceled }

extension LabReportStatusExtension on LabReportStatus {
  String get value => toString().split('.').last;
}

class LabReportModel {
  final String id;
  final DateTime deliveryTime;
  final String testName;
  final String testId;
  final LabReportStatus status;
  final List<String> attachedFiles;
  final String? note;
  final String patientId;

  LabReportModel({
    required this.id,
    required this.deliveryTime,
    required this.testName,
    required this.testId,
    required this.status,
    List<String>? attachedFiles,
    this.note,
    required this.patientId,
  }) : attachedFiles = attachedFiles ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'deliveryTime': deliveryTime.toIso8601String(),
        'testName': testName,
        'testId': testId,
        'status': status.value,
        'attachedFiles': attachedFiles,
        'note': note,
        'patientId': patientId,
      };

  factory LabReportModel.fromJson(Map<String, dynamic> json) => LabReportModel(
        id: json['id'],
        deliveryTime: DateTime.parse(json['deliveryTime']),
        testName: json['testName'],
        testId: json['testId'],
        status: LabReportStatus.values.firstWhere(
            (e) => e.value == json['status'],
            orElse: () => LabReportStatus.assigned),
        attachedFiles: (json['attachedFiles'] as List<dynamic>?)
                ?.map((f) => f.toString())
                .toList() ??
            [],
        note: json['note'],
        patientId: json['patientId'],
      );
}
