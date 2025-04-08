import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/inventory_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class InventoryViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<InventoryModel> inventory = <InventoryModel>[].obs;

  RxString userId = ''.obs;
  Rx<UserRole> userRole = UserRole.patient.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchInventory();
  }

  Future<void> initUser() async {
    final profile = Get.find<ProfileViewModel>().profile;

    userId.value = profile!.uid;
    userRole.value = profile!.role;
  }

  Future<void> fetchInventory() async {
    await initUser();

    try {
      final collection = userRole.value == UserRole.pharmacist
          ? 'pharmacy_inventory'
          : 'patient_inventory';

      final query = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId.value)
          .get();

      inventory.assignAll(query.docs
          .map((doc) => InventoryModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      print("Error fetching inventory: $e");
      // Handle the error appropriately
    }
  }

  Future<void> updateStock(String medicineId, int newQuantity) async {
    await initUser();

    try {
      // Define the collection based on the user role
      final collection = userRole.value == UserRole.pharmacist
          ? 'pharmacy_inventory'
          : 'patient_inventory';

      // Query Firestore for the document where userId and medicineId match
      final querySnapshot = await _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId.value)
          .where("medicineId", isEqualTo: medicineId)
          .get();

      // Update the stock for the matching medicineId
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'stock': newQuantity});
      }

      // Update the stock locally in the inventory list
      final index =
          inventory.indexWhere((item) => item.medicineId == medicineId);
      if (index != -1) {
        inventory[index].stock = newQuantity;
        inventory.refresh(); // Refresh the UI to reflect the change
      }
    } catch (e) {
      print("Error updating stock: $e");
      // Handle the error appropriately
    }
  }

  // Add medicine to patient inventory
  Future<void> addMedicineToInventory(
    String medicineId,
    int quantity,
  ) async {
    await initUser();

    final collection = userRole.value == UserRole.pharmacist
        ? 'pharmacy_inventory'
        : 'patient_inventory';

    final newInventoryItem = InventoryModel(
      medicineId: medicineId,
      userId: userId.value,
      stock: quantity,
    );

    try {
      // Check if the medicine already exists in the patient's inventory
      final querySnapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId.value)
          .where('medicineId', isEqualTo: medicineId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("Medicine does not exist in inventory, adding new entry...");
        await _firestore.collection(collection).add(newInventoryItem.toJson());
      } else {
        // Medicine already exists, update the quantity
        final doc = querySnapshot.docs.first;
        final existingQuantity = doc['stock'] ?? 0;

        print("Medicine exists, updating quantity...");
        await _firestore.collection(collection).doc(doc.id).update({
          'stock': existingQuantity + quantity,
        });
      }

      // Update the local inventory list
      final index =
          inventory.indexWhere((item) => item.medicineId == medicineId);

      if (index == -1) {
        // Medicine not in local inventory, add it
        inventory.add(newInventoryItem);
      } else {
        // Update the stock in local inventory
        inventory[index].stock += quantity;
      }

      inventory.refresh();
      print("Inventory updated successfully!");
    } catch (e) {
      print('Error adding medicine to inventory: $e');
    }
  }
}
