enum OrderStatus {
  processing,
  inProgress,
  completed,
  cancelled,
}

class OrderModel {
  final String id;
  final String patientId;
  final String? pharmacistId;
  final List<String> medicineIds;
  final DateTime orderTime; //Date when order will be delivered
  final OrderStatus status;
  final List<OrderUpdate> updates;
  final String? address;

  OrderModel({
    required this.id,
    required this.patientId,
    this.pharmacistId,
    required this.medicineIds,
    required this.orderTime,
    this.status = OrderStatus.processing,
    List<OrderUpdate>? updates,
    this.address,
  }) : updates = updates ?? [];

  // Convert OrderModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'pharmacistId': pharmacistId,
        'medicineIds': medicineIds,
        'orderTime': orderTime.toIso8601String(),
        'status': orderStatusToString(status),
        'updates': updates.map((u) => u.toJson()).toList(),
        'address': address,
      };

  // Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      patientId: json['patientId'],
      pharmacistId: json['pharmacistId'],
      medicineIds: List<String>.from(json['medicineIds']),
      orderTime: DateTime.parse(json['orderTime']),
      status: _stringToOrderStatus(json['status']),
      updates: (json['updates'] as List<dynamic>?)
          ?.map((u) => OrderUpdate.fromJson(u))
          .toList(),
      address: json['address'],
    );
  }

  // Helper: Convert OrderStatus enum to String
  static String orderStatusToString(OrderStatus status) {
    return status.toString().split('.').last;
  }

  // Helper: Convert String to OrderStatus enum
  static OrderStatus _stringToOrderStatus(String statusStr) {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusStr,
      orElse: () => OrderStatus.processing,
    );
  }

  // CopyWith method for immutable updates
  OrderModel copyWith({
    String? id,
    String? patientId,
    String? pharmacistId,
    List<String>? medicineIds,
    DateTime? orderTime,
    OrderStatus? status,
    List<OrderUpdate>? updates,
    String? address,
  }) {
    return OrderModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      pharmacistId: pharmacistId ?? this.pharmacistId,
      medicineIds: medicineIds ?? this.medicineIds,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      updates: updates ?? this.updates,
      address: address ?? this.address,
    );
  }
}

class OrderUpdate {
  final DateTime timestamp;
  final String message;

  OrderUpdate({required this.timestamp, required this.message});

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'message': message,
      };

  factory OrderUpdate.fromJson(Map<String, dynamic> json) => OrderUpdate(
        timestamp: DateTime.parse(json['timestamp']),
        message: json['message'],
      );
}
