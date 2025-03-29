import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';

class CheckoutView extends StatelessWidget {
  final OrderViewModel viewModel = Get.find();
  final List<MedicineItem> medicines;

  CheckoutView({Key? key, required this.medicines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Medicine Requests
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Medicine ${index + 1}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text("Name: ${medicine.name}"),
                          Text("Formula: ${medicine.formula}"),
                          Text("Quantity: ${medicine.quantity}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Create order from medicines
                  final order = OrderModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    patientId:
                        'currentPatientId', // You'll need to get this from auth
                    medicineIds: medicines
                        .map((m) => m.name)
                        .toList(), // Or generate proper IDs
                    orderTime: DateTime.now(),
                    status: OrderStatus.processing,
                    updates: [
                      OrderUpdate(
                        timestamp: DateTime.now(),
                        message: 'Order created',
                      ),
                    ],
                  );

                  // Save order (you'll need to implement this in OrderViewModel)
                  viewModel.createOrder(order);

                  // Navigate back
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "PLACE ORDER",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple model to represent medicine items (same as in RequestMedicneView)
class MedicineItem {
  final String name;
  final String formula;
  final int quantity;

  MedicineItem({
    required this.name,
    required this.formula,
    required this.quantity,
  });
}
