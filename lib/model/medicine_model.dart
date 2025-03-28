// medicine_model.dart (updated)
class MedicineModel {
  final String id;
  final String name;
  final String? formula;
  final String? description;
  int stock;

  MedicineModel({
    required this.id,
    required this.name,
    this.formula,
    this.description,
    this.stock = 0,
  });

  // Update toJson/fromJson to include stock
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'formula': formula,
        'description': description,
        'stock': stock,
      };

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        id: json['id'],
        name: json['name'],
        formula: json['formula'],
        description: json['description'],
        stock: json['stock'] ?? 0,
      );
}
