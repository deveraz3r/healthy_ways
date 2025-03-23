import 'package:flutter/material.dart';
import 'package:healty_ways/model/shared/inventory_medicne.dart';

class InventoryMedicneCard extends StatelessWidget {
  final Medicine medicine;

  const InventoryMedicneCard({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    bool isInStock = medicine.quantity <= 0 ? false : true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 1,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      height: 112,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Display medicine image or default picture
              Image.asset(
                "assets/images/pills.png", // Default image
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          medicine.formula, // Display formula
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${medicine.quantity.toString()} ${medicine.quantityType}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isInStock ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isInStock ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: isInStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
