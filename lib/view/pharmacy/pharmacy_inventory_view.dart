import 'package:healty_ways/resources/components/patient/inventory_medicne_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';

class PharmacyInventoryView extends StatelessWidget {
  PharmacyInventoryView({super.key});

  final InventoryViewModel _inventoryVM = Get.put(InventoryViewModel());
  final String currentUserId = "current_user_id"; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Inventory",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(RouteName.patientInventoryAddItem);
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
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _inventoryVM.inventory.length,
          itemBuilder: (context, index) {
            final medicine = _inventoryVM.inventory[index];
            return InventoryMedicneCard(
              medicine: medicine,
            );
          },
        );
      }),
    );
  }
}
