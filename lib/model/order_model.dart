import 'package:healty_ways/utils/app_urls.dart';

enum OrderStatus {
  processing,
  inProgress,
  completed,
  cancelled,
}

class OrderModel {
  String id;
  String patientId;
  String? pharmacistId;
  List<OrderMedsModel> medicines; // Updated to use OrderMedsModel
  DateTime orderTime; // Date when order will be delivered
  OrderStatus status;
  List<OrderUpdate> updates;
  String? address;

  OrderModel({
    required this.id,
    required this.patientId,
    this.pharmacistId,
    required this.medicines,
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
        'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
        'orderTime': orderTime.toIso8601String(),
        'status': orderStatusToString(status),
        'updates': updates.map((u) => u.toJson()).toList(),
        'address': address,
      };

  // Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '', // fallback to empty string
      patientId: json['patientId'] as String? ?? '',
      pharmacistId: json['pharmacistId'] as String?, // nullable
      medicines: (json['medicines'] as List<dynamic>? ?? [])
          .map((medicine) => OrderMedsModel.fromJson(medicine))
          .toList(),
      orderTime: DateTime.tryParse(json['orderTime'] ?? '') ?? DateTime.now(),
      status: _stringToOrderStatus(json['status'] ?? 'processing'),
      updates: (json['updates'] as List<dynamic>? ?? [])
          .map((u) => OrderUpdate.fromJson(u))
          .toList(),
      address: json['address'] as String?,
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
    List<OrderMedsModel>? medicines,
    DateTime? orderTime,
    OrderStatus? status,
    List<OrderUpdate>? updates,
    String? address,
  }) {
    return OrderModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      pharmacistId: pharmacistId ?? this.pharmacistId,
      medicines: medicines ?? this.medicines,
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
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
        message: json['message'] ?? '',
      );
}
