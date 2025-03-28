class ImmunizationModel {
  final String id;
  final String title;
  final String description;
  final String patientId;

  ImmunizationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.patientId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'patientId': patientId,
      };

  factory ImmunizationModel.fromJson(Map<String, dynamic> json) =>
      ImmunizationModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        patientId: json['patientId'],
      );
}
