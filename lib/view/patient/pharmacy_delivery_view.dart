import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/utils/routes/route_name.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/resources/components/shared/date_group_card.dart';

class PharmacyView extends StatelessWidget {
  final OrderViewModel orderVM = Get.put(OrderViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Pharmacy Orders',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () =>{
              Get.toNamed(
  RouteName.patientRequestMedicineCheckout,
  arguments: _medicines, // Pass the list of medicines
);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (orderVM.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        // Group orders by date
        final groupedOrders = _groupOrdersByDate(orderVM.orders);

        return RefreshIndicator(
          onRefresh: () async =>
              await orderVM.fetchUserOrders('currentUserId', true),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: groupedOrders.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final date = groupedOrders.keys.elementAt(index);
              final ordersForDate = groupedOrders[date]!;

              return DateGroupCard(
                date: date,
                orders: ordersForDate,
                onStatusChange: (orderId, newStatus) {
                  orderVM.updateOrderStatus(orderId, newStatus);
                },
              );
            },
          ),
        );
      }),
    );
  }

  Map<DateTime, List<OrderModel>> _groupOrdersByDate(List<OrderModel> orders) {
    final grouped = <DateTime, List<OrderModel>>{};

    for (final order in orders) {
      final date = DateTime(
        order.orderTime.year,
        order.orderTime.month,
        order.orderTime.day,
      );

      grouped.putIfAbsent(date, () => []).add(order);
    }

    return grouped;
  }
}
