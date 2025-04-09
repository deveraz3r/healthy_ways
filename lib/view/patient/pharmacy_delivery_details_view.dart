import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyDeliveryDetailsView extends StatelessWidget {
  final String orderId;

  const PharmacyDeliveryDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final OrderViewModel orderVM = Get.find<OrderViewModel>();

    // Find the order by ID with proper null check
    final OrderModel? order = orderVM.orders.firstWhereOrNull(
      (o) => o.id == orderId,
    );

    if (order == null) {
      return Scaffold(
        appBar: ReusableAppBar(
          titleText: 'Order Details',
          enableBack: true,
        ),
        body: const Center(
          child: Text('Order not found'),
        ),
      );
    }

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Order Details',
        enableBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.id.substring(0, 8)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getStatusText(order.status),
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Requested Date
            Text(
              'Requested: ${DateFormat('MMM dd, yyyy').format(order.orderTime)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            // Only show delivered date if status is completed
            if (order.status == OrderStatus.completed) ...[
              const SizedBox(height: 8),
              Text(
                'Delivered: ${DateFormat('MMM dd, yyyy').format(order.orderTime.add(const Duration(days: 1)))}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Medicines List
            Text(
              'Medicines:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...order.medicines.map(
              (medicineId) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    FutureBuilder<String>(
                      future: _getMedicineName(medicineId["id"]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return Text(
                          '${snapshot.data ?? 'Unknown Medicine'} (Qty: 1)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Update Messages
            Text(
              'Updates:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...order.updates.map(
              (update) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM dd, hh:mm a')
                                .format(update.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            update.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getMedicineName(String medicineId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('medicines')
          .doc(medicineId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['name'] ?? 'Unknown Medicine';
      }
      return 'Unknown Medicine';
    } catch (e) {
      return 'Unknown Medicine';
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
