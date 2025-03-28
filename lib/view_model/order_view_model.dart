import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';

class OrderViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<OrderModel> _orders = <OrderModel>[].obs;

  List<OrderModel> get orders => _orders;

  Future<void> fetchUserOrders(String userId, bool isPatient) async {
    final field = isPatient ? 'patientId' : 'pharmacistId';
    final query = await _firestore
        .collection('orders')
        .where(field, isEqualTo: userId)
        .orderBy('orderTime', descending: true)
        .get();

    _orders.assignAll(
        query.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final statusStr = OrderModel.orderStatusToString(newStatus);

    await _firestore.collection('orders').doc(orderId).update({
      'status': statusStr,
      'updates': FieldValue.arrayUnion([
        {
          'timestamp': DateTime.now().toIso8601String(),
          'message': 'Status changed to $statusStr'
        }
      ])
    });

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      _orders.refresh();
    }
  }

  // Helper method to get status as string
  String getStatusString(OrderStatus status) {
    return OrderModel.orderStatusToString(status);
  }
}
