import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/patient/pharmacy_delivery.dart';
import 'package:healty_ways/view/patient/pharmacy_delivery_details_view.dart';
import 'package:intl/intl.dart';

class DeliveryItemCard extends StatelessWidget {
  final DeliveryEntry delivery;

  const DeliveryItemCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    // Get the latest update message
    final latestUpdate = delivery.updateMessages.isNotEmpty
        ? delivery.updateMessages.last
        : 'No updates available';

    return InkWell(
      onTap: () {
        // Navigate to the detailed view
        Get.to(
          () => PharmacyDeliveryDetailsView(orderId: delivery.orderId),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${delivery.orderId}",
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Requested: ${DateFormat('MMM dd, yyyy').format(delivery.requestedDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Latest Update: $latestUpdate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
