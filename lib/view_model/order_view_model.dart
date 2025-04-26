import 'package:healty_ways/utils/app_urls.dart';

class OrderViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  var selectedStatus = OrderStatus.processing.obs;
  final Rx<OrderModel> order = Rx<OrderModel>(
    OrderModel(
      id: '',
      patientId: '',
      pharmacistId: '',
      medicines: [],
      orderTime: DateTime.now(),
      status: OrderStatus.processing,
      address: '',
    ),
  );

  Future<void> createOrder(OrderModel newOrder) async {
    try {
      final docRef = _firestore.collection('orders').doc();

      newOrder.id = docRef.id;
      newOrder.status = OrderStatus.processing;
      newOrder.orderTime = DateTime.now();
      newOrder.updates = [
        OrderUpdate(
          timestamp: DateTime.now(),
          message: 'Order Created By Pharmacist',
        )
      ];

      await docRef.set(newOrder.toJson());
      orders.add(newOrder);

      Get.snackbar('Success', 'Order placed successfully');
    } catch (e) {
      _handleError('Failed to place order', e);
    }
  }

  Future<void> fetchUserOrders(String userId, bool isPatient) async {
    try {
      final field = isPatient ? 'patientId' : 'pharmacistId';

      final query = await _firestore
          .collection('orders')
          .where(field, isEqualTo: userId)
          .get();

      final ordersList =
          query.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();

      ordersList.sort((a, b) => b.orderTime.compareTo(a.orderTime));

      orders.assignAll(ordersList);
    } catch (e) {
      _handleError("Failed to fetch orders", e);
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final statusStr = OrderModel.orderStatusToString(newStatus);

      await _firestore.collection('orders').doc(orderId).update({
        'status': statusStr,
        'updates': FieldValue.arrayUnion([
          {
            'timestamp': DateTime.now(),
            'message': 'Status changed to $statusStr',
          }
        ])
      });

      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(
          status: newStatus,
          updates: [
            OrderUpdate(
              message: 'Status changed to $statusStr',
              timestamp: DateTime.now(),
            )
          ],
        );

        orders.refresh();
      }
    } catch (e) {
      _handleError("Failed to update order status", e);
    }
  }

  void addMedicineToOrder(OrderMedsModel medicine) {
    try {
      final existingIndex =
          order.value.medicines.indexWhere((m) => m.id == medicine.id);

      if (existingIndex != -1) {
        order.update((o) {
          o?.medicines[existingIndex] = o.medicines[existingIndex].copyWith(
            stock: o.medicines[existingIndex].quantity + medicine.quantity,
          );
        });
      } else {
        order.update((o) {
          o?.medicines.add(medicine);
        });
      }
    } catch (e) {
      _handleError("Failed to add medicine to order", e);
    }
  }

  void setPatientId(String patientId) {
    try {
      order.update((o) {
        o?.patientId = patientId;
      });
    } catch (e) {
      _handleError("Failed to set patient ID", e);
    }
  }

  void setPharmacistId(String pharmacistId) {
    try {
      order.update((o) {
        o?.pharmacistId = pharmacistId;
      });
    } catch (e) {
      _handleError("Failed to set pharmacist ID", e);
    }
  }

  void setAddress(String address) {
    try {
      order.update((o) {
        o?.address = address;
      });
    } catch (e) {
      _handleError("Failed to set address", e);
    }
  }

  void resetOrder() {
    try {
      order.value = OrderModel(
        id: '',
        patientId: '',
        pharmacistId: '',
        medicines: [],
        orderTime: DateTime.now(),
        status: OrderStatus.processing,
        address: '',
      );
    } catch (e) {
      _handleError("Failed to reset order", e);
    }
  }

  Future<void> patientAcceptOrder(OrderModel order) async {
    try {
      final statusStr = OrderModel.orderStatusToString(OrderStatus.inProgress);

      await _firestore.collection('orders').doc(order.id).update({
        'status': statusStr,
        'updates': FieldValue.arrayUnion([
          {
            'timestamp': DateTime.now().toIso8601String(),
            'message': 'Order Accepted By patient'
          }
        ])
      });

      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: OrderStatus.inProgress);
        orders.refresh();
      }
    } catch (e) {
      _handleError("Failed to accept order", e);
    }
  }

  Future<void> patientDenyOrder(OrderModel order) async {
    try {
      final statusStr = OrderModel.orderStatusToString(OrderStatus.cancelled);

      await _firestore.collection('orders').doc(order.id).update({
        'status': statusStr,
        'updates': FieldValue.arrayUnion([
          {
            'timestamp': DateTime.now().toIso8601String(),
            'message': 'Order Rejected By patient'
          }
        ])
      });

      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: OrderStatus.cancelled);
        orders.refresh();
      }
    } catch (e) {
      _handleError("Failed to deny order", e);
    }
  }

  Future<void> sendOrderUpdate(String orderId, String message) async {
    try {
      final update = OrderUpdate(
        timestamp: DateTime.now(),
        message: message,
      );

      await _firestore.collection('orders').doc(orderId).update({
        'updates': FieldValue.arrayUnion([update.toJson()])
      });

      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final existingUpdates = List<OrderUpdate>.from(orders[index].updates);
        existingUpdates.add(update);

        orders[index] = orders[index].copyWith(updates: existingUpdates);
        orders.refresh();
      }

      Get.snackbar("Update Sent", "Message has been added to the order.");
    } catch (e) {
      _handleError("Failed to send order update", e);
    }
  }

  Future<void> pharmacistCancleOrder(OrderModel order) async {
    try {
      final statusStr = OrderModel.orderStatusToString(OrderStatus.cancelled);

      final OrderUpdate update = OrderUpdate(
        timestamp: DateTime.now(),
        message: 'Order Cancelled By pharmacist',
      );

      await _firestore.collection('orders').doc(order.id).update({
        'status': statusStr,
        'updates': FieldValue.arrayUnion([update.toJson()])
      });

      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index] = orders[index].copyWith(
          status: OrderStatus.cancelled,
          updates: [...orders[index].updates, update],
        );
        orders.refresh();
      }
    } catch (e) {
      _handleError("Failed to cancel order", e);
    }
  }

  void _handleError(String message, Object error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
