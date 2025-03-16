import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/reusable_app_bar.dart';
import 'package:healty_ways/utils/routes/route_name.dart';
import 'package:healty_ways/view_model/patient/pharmacy_delivery_view_model.dart';
import 'package:healty_ways/resources/components/date_group_card.dart';

class PharmacyView extends StatelessWidget {
  PharmacyView({super.key});

  final PharmacyDeliveryViewModel deliveryViewModel =
      Get.put(PharmacyDeliveryViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Pharmacy Delivery',
        // enableBack: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Navigate to the request medication page
              Get.toNamed(RouteName.patientRequestMedication);
            },
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: deliveryViewModel.deliveries.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final delivery = deliveryViewModel.deliveries[index];
            return DateGroupCard(delivery: delivery); // Use the DateGroupCard
          },
        );
      }),
    );
  }
}
