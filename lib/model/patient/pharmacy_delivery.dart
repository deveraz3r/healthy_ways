enum DeliveryStatus {
  notStarted,
  inProgress,
  completed,
  returned,
}

class Medicine {
  final String name;
  final int quantity;

  Medicine({
    required this.name,
    required this.quantity,
  });
}

class DeliveryEntry {
  final String orderId;
  final DeliveryStatus status;
  final DateTime requestedDate;
  final DateTime? deliveredDate;
  final List<String> updateMessages;
  final List<Medicine> medicines; // Add medicines list

  DeliveryEntry({
    required this.orderId,
    required this.status,
    required this.requestedDate,
    this.deliveredDate,
    required this.updateMessages,
    required this.medicines, // Initialize medicines
  });
}

// Model for Medicine Delivery
class PharmacyDelivery {
  final DateTime date;
  final List<DeliveryEntry> deliveries;
  final String dayAbbreviation;
  final String monthAbbreviation;

  PharmacyDelivery({
    required this.date,
    required this.deliveries,
    required this.dayAbbreviation,
    required this.monthAbbreviation,
  });
}
