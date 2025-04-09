import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/patient/inventory_medicne_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';

class PharmacyInventoryView extends StatelessWidget {
  PharmacyInventoryView({super.key});

  final InventoryViewModel inventoryViewModel = Get.put(InventoryViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Pharmacy Inventory",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(RouteName.pharmacyInventoryAddItem);
            },
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await inventoryViewModel.fetchInventory(); // fetch latest
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: inventoryViewModel.inventory.length,
            itemBuilder: (context, index) {
              final inventoryItem = inventoryViewModel.inventory[index];
              return InventoryMedicneCard(
                medicine: Get.find<MedicineViewModel>()
                    .getMedicine(inventoryItem.medicineId),
                stock: inventoryItem.stock,
              );
            },
          ),
        );
      }),
    );
  }
}
