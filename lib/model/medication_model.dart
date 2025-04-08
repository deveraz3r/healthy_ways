class MedicationModel {
  final String id;
  final String medicineId;
  final int quantity;
  final DateTime assignedTime;
  final String assignedTo; //patient
  final String assignedBy; //doctor or pharmacist
  bool isTaken;

  MedicationModel({
    required this.id,
    required this.medicineId,
    required this.quantity,
    required this.assignedTime,
    required this.assignedTo,
    required this.assignedBy,
    this.isTaken = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicineId': medicineId,
        'quantity': quantity,
        'assignedTime': assignedTime.toIso8601String(),
        'assignedTo': assignedTo,
        'assignedBy': assignedBy,
        'isTaken': isTaken,
      };

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel(
        id: json['id'],
        medicineId: json['medicineId'],
        quantity: json['quantity'],
        assignedTime: DateTime.parse(json['assignedTime']),
        assignedTo: json['assignedTo'],
        assignedBy: json['assignedBy'],
        isTaken: json['isTaken'] ?? false,
      );
}
