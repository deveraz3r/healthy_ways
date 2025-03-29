import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/medicine_model.dart';

class InventoryViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<MedicineModel> inventory = <MedicineModel>[].obs;

  Future<void> fetchInventory(String userId, String userType) async {
    final collection =
        userType == 'pharmacist' ? 'pharmacy_inventory' : 'patient_inventory';

    final query = await _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .get();

    inventory.assignAll(
        query.docs.map((doc) => MedicineModel.fromJson(doc.data())).toList());
  }

  Future<void> updateStock(String docId, int newQuantity) async {
    await _firestore
        .collection('inventory')
        .doc(docId)
        .update({'stock': newQuantity});
    final index = inventory.indexWhere((item) => item.id == docId);
    if (index != -1) {
      inventory[index].stock = newQuantity;
      inventory.refresh();
    }
  }
}
