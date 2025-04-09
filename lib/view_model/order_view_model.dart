import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';

class OrderViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var selectedStatus = OrderStatus.processing.obs;
  // Initialize the reactive order with a valid instance
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

  final RxList<OrderModel> _orders = <OrderModel>[].obs;

  List<OrderModel> get orders => _orders;

  // ✅ Create a new order and save it to Firestore
  Future<void> createOrder(
    OrderModel order,
  ) async {
    try {
      final newOrder = OrderModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: order.patientId,
          pharmacistId: order.pharmacistId,
          medicines: order.medicines,
          orderTime: order.orderTime,
          status: OrderStatus.processing,
          address: order.address,
          updates: [
            OrderUpdate(
              timestamp: DateTime.now(),
              message: 'Order Created By Pharmacist',
            )
          ]);

      await _firestore
          .collection('orders')
          .doc(newOrder.id)
          .set(newOrder.toJson());
      _orders.add(newOrder);

      Get.snackbar('Success', 'Order placed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    }
  }

  // ✅ Fetch user-specific orders
  Future<void> fetchUserOrders(String userId, bool isPatient) async {
    try {
      final field = isPatient ? 'patientId' : 'pharmacistId';

      final query = await _firestore
          .collection('orders')
          .where(field, isEqualTo: userId)
          .get();

      final orders =
          query.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();

      orders.sort((a, b) => b.orderTime.compareTo(a.orderTime));

      _orders.assignAll(orders);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ✅ Update order status both in Firestore and locally
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

  // ✅ Utility for status string
  String getStatusString(OrderStatus status) {
    return OrderModel.orderStatusToString(status);
  }

  // ✅ Helper: Add a medicine with quantity to current reactive order
  void addMedicineToOrder(String medicineId, int quantity) {
    if (!order.value.medicines.any((item) => item['id'] == medicineId)) {
      order.update((o) {
        o?.medicines.add({
          'id': medicineId,
          'quantity': quantity,
        });
      });
    }
  }

  // ✅ Helper: Set patient ID
  void setPatientId(String patientId) {
    order.update((o) {
      o?.patientId = patientId;
    });
  }

  // ✅ Helper: Set pharmacist ID (for order)
  void setPharmacistId(String pharmacistId) {
    order.update((o) {
      o?.pharmacistId = pharmacistId;
    });
  }

  // ✅ Helper: Set order address
  void setAddress(String address) {
    order.update((o) {
      o?.address = address;
    });
  }

  // ✅ Helper: Reset the order (use after submitting)
  void resetOrder() {
    order.value = OrderModel(
      id: '',
      patientId: '',
      pharmacistId: '',
      medicines: [],
      orderTime: DateTime.now(),
      status: OrderStatus.processing,
      address: '',
    );
  }

  Future<void> patientAcceptOrder(OrderModel order) async {
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

    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.inProgress);
      _orders.refresh();
    }
  }

  Future<void> patientDenyOrder(OrderModel order) async {
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

    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
      _orders.refresh();
    }
  }

  Future<void> sendOrderUpdate(String orderId, String message) async {
    try {
      final update = {
        'timestamp': DateTime.now().toIso8601String(),
        'message': message,
      };

      await _firestore.collection('orders').doc(orderId).update({
        'updates': FieldValue.arrayUnion([update])
      });

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final existingUpdates = List<OrderUpdate>.from(_orders[index].updates);
        existingUpdates.add(OrderUpdate(
          message: message,
          timestamp: DateTime.now(),
        ));

        _orders[index] = _orders[index].copyWith(updates: existingUpdates);
        _orders.refresh();
      }

      Get.snackbar("Update Sent", "Message has been added to the order.");
    } catch (e) {
      Get.snackbar("Error", "Failed to send update: $e");
    }
  }

  void pharmacistCancleOrder(OrderModel order) async {
    final statusStr = OrderModel.orderStatusToString(OrderStatus.cancelled);

    await _firestore.collection('orders').doc(order.id).update({
      'status': statusStr,
      'updates': FieldValue.arrayUnion([
        {
          'timestamp': DateTime.now().toIso8601String(),
          'message': 'Order Cancled by pharmacist'
        }
      ])
    });

    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
      _orders.refresh();
    }
  }
}
