import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/pharmacy/pharmacy_order_requests_view_model.dart';

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)), // Border radius 5
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class PharmacyOrdersRequestView extends StatelessWidget {
  final PharmacyOrderRequestsViewModel controller =
      Get.put(PharmacyOrderRequestsViewModel());

  PharmacyOrdersRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ("Order Requests"),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.home,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                                    order?.patientImage ??
                                        "assets/images/profile.jpg"),
                              ),
                              const SizedBox(width: 5),
                              Text(order.patientName),
                            ],
                          ),
                          const Divider(),
                          Column(
                            children: order.medicines.map((medicine) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(medicine.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(medicine.quantity,
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(medicine.dosage,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                                onPressed: () => controller.approveOrder(index),
                                color: AppColors.greenColor,
                              ),
                              const SizedBox(width: 10),
                              CustomElevatedButton(
                                text: "Reject",
                                onPressed: () => controller.rejectOrder(index),
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
            },
          );
        }),
      ),
    );
  }
}
