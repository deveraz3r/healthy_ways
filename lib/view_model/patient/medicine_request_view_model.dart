import 'package:get/get.dart';
import 'package:healty_ways/model/patient/medicine_request.dart';

class MedicineRequestViewModel extends GetxController {
  // Reactive list of medicine requests
  final RxList<MedicineRequest> medicineRequests = <MedicineRequest>[].obs;

  // Add a new medicine request
  void addMedicineRequest(MedicineRequest request) {
    medicineRequests.add(request);
  }

  // Clear all medicine requests
  void clearMedicineRequests() {
    medicineRequests.clear();
  }
}
