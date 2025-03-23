import 'package:flutter/material.dart';
import 'package:healty_ways/model/patient/pharmacy_delivery.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:intl/intl.dart';
import '../patient/delivery_item_card.dart'; // Import the DeliveryItemCard component

class DateGroupCard extends StatelessWidget {
  final PharmacyDelivery delivery;

  const DateGroupCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Card
        Container(
          width: 45,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                delivery.monthAbbreviation,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                delivery.dayAbbreviation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Deliveries Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(delivery.date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              ...delivery.deliveries
                  .map((delivery) => DeliveryItemCard(delivery: delivery)),
            ],
          ),
        ),
      ],
    );
  }
}
