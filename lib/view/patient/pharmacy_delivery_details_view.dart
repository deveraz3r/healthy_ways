import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/patient/pharmacy_delivery.dart';
import 'package:healty_ways/resources/components/reusable_app_bar.dart';
import 'package:healty_ways/view_model/patient/pharmacy_delivery_view_model.dart';
import 'package:intl/intl.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

class PharmacyDeliveryDetailsView extends StatelessWidget {
  final String orderId; // Order ID to fetch details

  const PharmacyDeliveryDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final PharmacyDeliveryViewModel deliveryViewModel =
        Get.find<PharmacyDeliveryViewModel>();

    // Find the delivery entry by orderId
    final DeliveryEntry? delivery = deliveryViewModel.deliveries
        .expand((delivery) => delivery.deliveries)
        .firstWhereOrNull((entry) => entry.orderId == orderId);

    if (delivery == null) {
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
                  "Order #${delivery.orderId}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  delivery.status.name, // Use enum's name property
                  style: TextStyle(
                    color: delivery.status == DeliveryStatus.completed
                        ? Colors.green
                        : delivery.status == DeliveryStatus.returned
                            ? Colors.red
                            : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Requested Date
            Text(
              'Requested: ${DateFormat('MMM dd, yyyy').format(delivery.requestedDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (delivery.deliveredDate != null) ...[
              const SizedBox(height: 8),
              // Delivered Date
              Text(
                'Delivered: ${DateFormat('MMM dd, yyyy').format(delivery.deliveredDate!)}',
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
            ...delivery.medicines.map(
              (medicine) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${medicine.name} (Qty: ${medicine.quantity})',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
            ...delivery.updateMessages.map(
              (message) => Padding(
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
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
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
}
