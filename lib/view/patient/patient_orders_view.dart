import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/utils/routes/route_name.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/view_model/patients_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PatientOrdersView extends StatelessWidget {
  final OrderViewModel orderVM = Get.put(OrderViewModel());
  final PatientsViewModel patientsVM = Get.put(PatientsViewModel());

  PatientOrdersView({super.key});

  Future<void> _refreshOrders() async {
    String? profileUid = Get.find<ProfileViewModel>().profile!.uid;

    if (profileUid != null) {
      await orderVM.fetchUserOrders(profileUid, true);
    } else {
      Get.snackbar("Error", "Profile is is not loaded yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Orders',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => {
              Get.toNamed(RouteName.patientContactPharmacistView),
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: orderVM.orders.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(child: Text("No orders found")),
                    ),
                  )
                : ListView.builder(
                    itemCount: orderVM.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderVM.orders[index];
                      return _buildOrderCard(order);
                    },
                  ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return FutureBuilder<PharmacistModel?>(
      future: Get.find<ProfileViewModel>()
          .getProfileDataById<PharmacistModel>(order.pharmacistId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final pharmacist = snapshot.data;

        if (pharmacist == null) {
          return const Center(child: Text('Pharmacist not found'));
        }

        Color statusColor = _getStatusColor(order.status);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                          backgroundImage: pharmacist.profileImage != null
                              ? NetworkImage(pharmacist.profileImage!)
                              : const AssetImage("assets/images/profile.jpg")
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 5),
                        Text(pharmacist.fullName ?? "Unknown"),
                        Spacer(),
                        Text(
                          DateFormat('MM-dd-yyyy hh:mm a')
                              .format(order.orderTime),
                        ),
                      ],
                    ),
                    const Divider(),
                    Column(
                      children: (order.medicines ?? []).map((medicine) {
                        final name = Get.find<MedicineViewModel>()
                            .getMedicineNameById(medicine["id"]);
                        final quantity = medicine["quantity"] ?? "N/A";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Quantity: $quantity",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Status: ${order.status.toString().split('.').last}",
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _getActionButton(order) ?? const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                Column(
                  children: List.generate(
                      2,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          )),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.inProgress:
        return Colors.orange;
      case OrderStatus.processing:
      default:
        return Colors.deepPurple;
    }
  }

  Widget? _getActionButton(OrderModel order) {
    // String patientId = Get.find<ProfileViewModel>().profile?.uid ?? "null";

    switch (order.status) {
      case OrderStatus.processing:
        return Row(
          children: [
            CustomElevatedButton(
              text: "Accept",
              onPressed: () {
                orderVM.patientAcceptOrder(order);
              },
              color: Colors.green,
            ),
            SizedBox(width: 5),
            CustomElevatedButton(
              text: "Deny",
              onPressed: () {
                orderVM.patientDenyOrder(order);
              },
              color: Colors.red,
            ),
          ],
        );
      case OrderStatus.inProgress:
        return CustomElevatedButton(
          text: "Status",
          onPressed: () {
            Get.toNamed(
              RouteName.patientOrdersDetailsView,
              arguments: order,
            );
          },
          color: Colors.orange,
        );
      case OrderStatus.completed:
        return CustomElevatedButton(
          text: "View Report",
          onPressed: () {
            Get.toNamed(
              RouteName.patientOrdersDetailsView,
              arguments: order,
            );
          },
          color: Colors.green,
        );
      case OrderStatus.cancelled:
        return null;
    }
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
