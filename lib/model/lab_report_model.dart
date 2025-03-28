class LabReportModel {
  final String id;
  final String testName;
  final String patientId;
  final DateTime date;
  final LabReportStatus status;
  final String? note;
  final List<String>? attachedFiles;

  LabReportModel({
    required this.id,
    required this.testName,
    required this.patientId,
    required this.date,
    this.status = LabReportStatus.assigned,
    this.note,
    this.attachedFiles,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'testName': testName,
        'patientId': patientId,
        'date': date.toIso8601String(),
        'status': status.toString().split('.').last,
        'note': note,
        'attachedFiles': attachedFiles,
      };

  factory LabReportModel.fromJson(Map<String, dynamic> json) {
    // Helper function to convert string to enum
    LabReportStatus statusFromString(String statusStr) {
      return LabReportStatus.values.firstWhere(
        (e) => e.toString().split('.').last == statusStr,
        orElse: () => LabReportStatus.assigned,
      );
    }

    return LabReportModel(
      id: json['id'],
      testName: json['testName'],
      patientId: json['patientId'],
      date: DateTime.parse(json['date']),
      status: statusFromString(json['status'] as String),
      note: json['note'],
      attachedFiles: json['attachedFiles'] != null
          ? List<String>.from(json['attachedFiles'])
          : null,
    );
  }

  LabReportModel copyWith({
    String? id,
    String? testName,
    String? patientId,
    DateTime? date,
    LabReportStatus? status,
    String? note,
    List<String>? attachedFiles,
  }) {
    return LabReportModel(
      id: id ?? this.id,
      testName: testName ?? this.testName,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      status: status ?? this.status,
      note: note ?? this.note,
      attachedFiles: attachedFiles ?? this.attachedFiles,
    );
  }
}

enum LabReportStatus {
  assigned,
  inProgress,
  completed,
  cancelled,
}
