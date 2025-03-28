enum EntryAddedBy { doctor, patient }

extension EntryAddedByExtension on EntryAddedBy {
  String get value => toString().split('.').last;
}

class DiaryEntryModel {
  final String id;
  final String patientId;
  final String? doctorId;
  final EntryAddedBy addedBy;
  final String title;
  final String body;
  final DateTime lastEdited;

  DiaryEntryModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.addedBy,
    required this.title,
    required this.body,
    required this.lastEdited,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
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
        addedBy: EntryAddedBy.values.firstWhere(
            (e) => e.value == json['addedBy'],
            orElse: () => EntryAddedBy.patient),
        title: json['title'],
        body: json['body'],
        lastEdited: DateTime.parse(json['lastEdited']),
      );
}
