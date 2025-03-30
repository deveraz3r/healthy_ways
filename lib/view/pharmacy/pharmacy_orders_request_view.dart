import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/order_view_model.dart';

class PharmacyOrdersRequestView extends StatelessWidget {
  final OrderViewModel _orderVM = Get.put(OrderViewModel());
  final String currentUserId =
      "pharmacist_id"; // Replace with actual pharmacist ID

  PharmacyOrdersRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Order Requests",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (_orderVM.orders.isEmpty) {
            return const Center(child: Text("No order requests found"));
          }

          return ListView.builder(
            itemCount: _orderVM.orders.length,
            itemBuilder: (context, index) {
              final order = _orderVM.orders[index];
              return _buildOrderCard(order, index);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage(
                        // order.patientImage ?? "assets/images/profile.jpg",
                        "assets/images/profile.jpg", //TODO: replace with actual profile
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Text(order.patientName),
                    Text("patient name"), //TODO: REPLACE WITH PATIENT NAME
                  ],
                ),
                const Divider(),
                Column(
                  children: order.medicineIds.map((medicineId) {
                    // You'll need to fetch actual medicine details here
                    // This is a placeholder - replace with your actual medicine data
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(medicineId, // Replace with medicine name
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Text(
                                  "Quantity: 1", // Replace with actual quantity
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const Spacer(),
                          const Text("1x daily", // Replace with actual dosage
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      text: "Approve",
                      onPressed: () => _approveOrder(order.id),
                      color: AppColors.greenColor,
                    ),
                    const SizedBox(width: 10),
                    CustomElevatedButton(
                      text: "Reject",
                      onPressed: () => _rejectOrder(order.id),
                      color: AppColors.redColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _approveOrder(String orderId) async {
    await _orderVM.updateOrderStatus(orderId, OrderStatus.inProgress);
    Get.snackbar("Success", "Order approved");
  }

  Future<void> _rejectOrder(String orderId) async {
    await _orderVM.updateOrderStatus(orderId, OrderStatus.cancelled);
    Get.snackbar("Success", "Order rejected");
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
