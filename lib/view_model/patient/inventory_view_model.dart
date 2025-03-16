import 'package:get/get.dart';
import 'package:healty_ways/model/patient/inventory_medicne.dart';

class InventoryViewModel extends GetxController {
  // List of medicines (reactive)
  final RxList<Medicine> medicines = <Medicine>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load medicines when the ViewModel is initialized
    _loadMedicines();
  }

  // Simulate loading medicines (replace with API call in a real app)
  void _loadMedicines() {
    final List<Medicine> loadedMedicines = [
      Medicine(
        name: 'Panadol Extra',
        formula: '100 mg',
        quantityType: 'Packs',
        quantity: 3,
        imageUrl: 'https://example.com/panadol.png',
      ),
      Medicine(
        name: 'Paracetamol',
        formula: '50 mg',
        quantityType: 'Packs',
        quantity: 3,
        imageUrl: null, // No image URL
      ),
      Medicine(
        name: 'Ibuprofen',
        formula: '500 mg',
        quantityType: 'Tablets',
        quantity: 3,
        imageUrl: 'https://example.com/ibuprofen.png',
      ),
    ];

    medicines.assignAll(loadedMedicines); // Update the reactive list
  }
}
