class MedicineModel {
  final int id;
  final String name;
  final String formula;
  final String? description;
  final String stockType;
  int stock;
  final String? imageUrl;

  MedicineModel({
    required this.id,
    required this.name,
    required this.formula,
    required this.stockType,
    this.description,
    this.stock = 0,
    this.imageUrl,
  });

  // Update toJson/fromJson to include stock
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': formula,
        'dosageType': stockType,
        'description': description,
        'stock': stock,
        'imageUrl': imageUrl,
      };

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        id: json['id'],
        name: json['name'],
        formula: json['dosage'],
        stockType: json['dosageType'],
        description: json['description'],
        stock: json['stock'] ?? 0,
        imageUrl: json['imageUrl'],
      );
}
