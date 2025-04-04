import 'package:healty_ways/model/user_model.dart';

class DiaryEntryModel {
  String id;
  final String patientId;
  final String? doctorId;
  final String? pharmacistId;
  final UserRole addedBy;
  final String title;
  final String body;
  final DateTime lastEdited;

  DiaryEntryModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    this.pharmacistId,
    required this.addedBy,
    required this.title,
    required this.body,
    required this.lastEdited,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'pharmacistId': pharmacistId,
        'addedBy': addedBy.value,
        'title': title,
        'body': body,
        'lastEdited': lastEdited.toIso8601String(),
      };

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) =>
      DiaryEntryModel(
        id: json['id'],
        patientId: json['patientId'],
        doctorId: json['doctorId'],
        pharmacistId: json['pharmacistId'],
        addedBy: UserRole.values.firstWhere((e) => e.value == json['addedBy'],
            orElse: () => UserRole.patient),
        title: json['title'],
        body: json['body'],
        lastEdited: DateTime.parse(json['lastEdited']),
      );

  DiaryEntryModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? pharmacistId,
    UserRole? addedBy,
    String? title,
    String? body,
    DateTime? lastEdited,
  }) {
    return DiaryEntryModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      pharmacistId: pharmacistId ?? this.pharmacistId,
      addedBy: addedBy ?? this.addedBy,
      title: title ?? this.title,
      body: body ?? this.body,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }
}
