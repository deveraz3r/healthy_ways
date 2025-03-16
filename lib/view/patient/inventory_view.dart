import 'package:healty_ways/view_model/patient/inventory_view_model.dart';
import 'package:healty_ways/resources/components/inventory_medicne_card.dart';
import 'package:healty_ways/utils/app_urls.dart';

class InventoryView extends StatelessWidget {
  InventoryView({super.key});

  final InventoryViewModel inventoryViewModel = Get.put(InventoryViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Inventory",
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
          itemCount: inventoryViewModel.medicines.length,
          itemBuilder: (context, index) {
            final medicine = inventoryViewModel.medicines[index];
            return InventoryMedicneCard(
              medicine: medicine,
            );
          },
        );
      }),
    );
  }
}
