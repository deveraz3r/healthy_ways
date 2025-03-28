class PatientInventoryModel {
  final String medicineId;
  final int stock;
  final String patientId;

  PatientInventoryModel({
    required this.medicineId,
    required this.stock,
    required this.patientId,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'stock': stock,
        'patientId': patientId,
      };

  factory PatientInventoryModel.fromJson(Map<String, dynamic> json) =>
      PatientInventoryModel(
        medicineId: json['medicineId'],
        stock: json['stock'],
        patientId: json['patientId'],
      );
}
