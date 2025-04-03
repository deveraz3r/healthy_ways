class AllergyModel {
  final String id;
  final String title;
  final String description;
  final String patientId;

  AllergyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.patientId,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'patientId': patientId,
      };

  factory AllergyModel.fromJson(Map<String, dynamic> json) => AllergyModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        patientId: json['patientId'],
      );

  AllergyModel copyWith({String? id}) {
    return AllergyModel(
      id: id ?? this.id,
      title: title,
      description: description,
      patientId: patientId,
    );
  }
}
