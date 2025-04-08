class InventoryModel {
  final String medicineId;
  int stock;
  final String userId;

  InventoryModel({
    required this.medicineId,
    required this.stock,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'stock': stock,
        'userId': userId,
      };

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        medicineId: json['medicineId'],
        stock: json['stock'],
        userId: json['userId'],
      );
}
