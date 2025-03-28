import 'package:get/get.dart';
import 'package:healty_ways/model/medicine_model.dart';

class MedicineViewModel extends GetxController {
  final RxList<MedicineModel> _medicines = <MedicineModel>[].obs;
  List<MedicineModel> get medicines => _medicines;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _medicines.addAll([
      MedicineModel(
        id: 'med1',
        name: 'Paracetamol',
        formula: 'C8H9NO2',
        description: 'Pain reliever and fever reducer',
      ),
      MedicineModel(
        id: 'med2',
        name: 'Ibuprofen',
        formula: 'C13H18O2',
        description: 'Anti-inflammatory medication',
      ),
    ]);
  }

  void addMedicine(MedicineModel medicine) {
    _medicines.add(medicine);
  }

  void removeMedicine(String id) {
    _medicines.removeWhere((medicine) => medicine.id == id);
  }

  MedicineModel? getMedicineById(String id) {
    try {
      return _medicines.firstWhere((medicine) => medicine.id == id);
    } catch (e) {
      return null;
    }
  }
}
