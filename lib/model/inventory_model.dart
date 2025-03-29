class InventoryModel {
  final String medicineId;
  final int stock;
  final String patientId;

  InventoryModel({
    required this.medicineId,
    required this.stock,
    required this.patientId,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'stock': stock,
        'patientId': patientId,
      };

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        medicineId: json['medicineId'],
        stock: json['stock'],
        patientId: json['patientId'],
      );
}
