import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/medicine_model.dart';

class InventoryViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<MedicineModel> _inventory = <MedicineModel>[].obs;

  List<MedicineModel> get inventory => _inventory;

  Future<void> fetchInventory(String userId, String userType) async {
    final collection =
        userType == 'pharmacist' ? 'pharmacy_inventory' : 'patient_inventory';

    final query = await _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .get();

    _inventory.assignAll(
        query.docs.map((doc) => MedicineModel.fromJson(doc.data())).toList());
  }

  Future<void> updateStock(String docId, int newQuantity) async {
    await _firestore
        .collection('inventory')
        .doc(docId)
        .update({'stock': newQuantity});
    final index = _inventory.indexWhere((item) => item.id == docId);
    if (index != -1) {
      _inventory[index].stock = newQuantity;
      _inventory.refresh();
    }
  }
}
