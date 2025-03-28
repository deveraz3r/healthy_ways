import 'package:healty_ways/model/order_update_model.dart';

enum OrderStatus { processing, inProgress, completed }

extension OrderStatusExtension on OrderStatus {
  String get value => toString().split('.').last;
}

class OrderRequestModel {
  final String orderId;
  final String orderedBy;
  final bool isAccepted;
  final OrderStatus orderStatus;
  final List<OrderUpdateModel> orderUpdates;
  final DateTime orderTime;
  final String address;

  OrderRequestModel({
    required this.orderId,
    required this.orderedBy,
    required this.isAccepted,
    required this.orderStatus,
    List<OrderUpdateModel>? orderUpdates,
    required this.orderTime,
    required this.address,
  }) : orderUpdates = orderUpdates ?? [];

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'orderedBy': orderedBy,
        'isAccepted': isAccepted,
        'orderStatus': orderStatus.value,
        'orderUpdates': orderUpdates.map((u) => u.toJson()).toList(),
        'orderTime': orderTime.toIso8601String(),
        'address': address,
      };

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderRequestModel(
        orderId: json['orderId'],
        orderedBy: json['orderedBy'],
        isAccepted: json['isAccepted'],
        orderStatus: OrderStatus.values.firstWhere(
            (e) => e.value == json['orderStatus'],
            orElse: () => OrderStatus.processing),
        orderUpdates: (json['orderUpdates'] as List<dynamic>?)
                ?.map((u) => OrderUpdateModel.fromJson(u))
                .toList() ??
            [],
        orderTime: DateTime.parse(json['orderTime']),
        address: json['address'],
      );
}
