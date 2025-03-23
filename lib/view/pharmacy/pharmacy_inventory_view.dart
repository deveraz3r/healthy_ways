import 'package:healty_ways/resources/components/patient/inventory_medicne_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/pharmacy/pharmacy_inventory_view_model.dart';

class PharmacyInventoryView extends StatelessWidget {
  PharmacyInventoryView({super.key});

  final PharmacyInventoryViewModel _pharmacyInventoryViewModel =
      Get.put(PharmacyInventoryViewModel());

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
          itemCount: _pharmacyInventoryViewModel.medicines.length,
          itemBuilder: (context, index) {
            final medicine = _pharmacyInventoryViewModel.medicines[index];
            return InventoryMedicneCard(
              medicine: medicine,
            );
          },
        );
      }),
    );
  }
}
