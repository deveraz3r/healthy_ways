class Medications {
  final String medicationName;
  final int dosage;
  final String dosageType;
  final String assignedBy;
  final DateTime time;
  bool isTaken;

  Medications({
    required this.medicationName,
    required this.dosage,
    required this.dosageType,
    required this.assignedBy,
    required this.time,
    required this.isTaken,
  });
}
