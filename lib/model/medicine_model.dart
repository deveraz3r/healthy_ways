class MedicineModel {
  final String id;
  final String name;
  final String? formula;
  final String? description;

  MedicineModel({
    required this.id,
    required this.name,
    this.formula,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'formula': formula,
        'description': description,
      };

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        id: json['id'],
        name: json['name'],
        formula: json['formula'],
        description: json['description'],
      );
}
