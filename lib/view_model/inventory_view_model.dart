import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/inventory_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
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

      inventory.value =
          query.docs.map((doc) => InventoryModel.fromJson(doc.data())).toList();
    } catch (e) {
      _handleError("Failed to fetch inventory", e);
    }
  }

  Future<void> updateStock(InventoryModel medicine) async {
    await initUser();

    try {
      // Define the collection based on the user role
      final collection = userRole.value == UserRole.pharmacist
          ? 'pharmacy_inventory'
          : 'patient_inventory';

      medicine.userId = userId.value;

      // Query Firestore for the document where userId and medicineId match
      final querySnapshot = await _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId.value)
          .where("medicineId", isEqualTo: medicine.medicineId)
          .get();

      // Update the stock for the matching medicineId
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'stock': medicine.stock});
      }

      // Update the stock locally in the inventory list
      final index = inventory
          .indexWhere((item) => item.medicineId == medicine.medicineId);
      if (index != -1) {
        inventory[index].stock = medicine.stock;
        inventory.refresh(); // Refresh the UI to reflect the change
      }
    } catch (e) {
      _handleError("Failed to update stock", e);
    }
  }

  // Add medicine to patient inventory
  Future<void> addMedicineToInventory(
    InventoryModel newMedicine,
  ) async {
    await initUser();

    final collection = userRole.value == UserRole.pharmacist
        ? 'pharmacy_inventory'
        : 'patient_inventory';

    newMedicine.userId = userId.value;

    try {
      // Check if the medicine already exists in the patient's inventory
      final querySnapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId.value)
          .where('medicineId', isEqualTo: newMedicine.medicineId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _firestore.collection(collection).add(newMedicine.toJson());
      } else {
        // Medicine already exists, update the quantity
        final doc = querySnapshot.docs.first;
        final existingQuantity = doc['stock'] ?? 0;

        await _firestore.collection(collection).doc(doc.id).update({
          'stock': existingQuantity + newMedicine.stock,
        });
      }

      // Update the local inventory list
      final index = inventory
          .indexWhere((item) => item.medicineId == newMedicine.medicineId);

      if (index == -1) {
        // Medicine not in local inventory, add it
        inventory.add(newMedicine);
      } else {
        // Update the stock in local inventory
        inventory[index].stock += newMedicine.stock;
      }

      inventory.refresh();
    } catch (e) {
      _handleError("Failed to add medicine to inventory", e);
    }
  }

  Future<void> revertStock(String medicineId, int quantity) async {
    try {
      final collection = userRole.value == UserRole.pharmacist
          ? 'pharmacy_inventory'
          : 'patient_inventory';

      final querySnapshot = await _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId.value)
          .where("medicineId", isEqualTo: medicineId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final currentStock = doc['stock'] ?? 0;

        await doc.reference.update({'stock': currentStock + quantity});
      }
    } catch (e) {
      _handleError("Failed to revert stock", e);
    }
  }

  Future<bool> deductStock(String medicineId, int quantity) async {
    try {
      final collection = userRole.value == UserRole.pharmacist
          ? 'pharmacy_inventory'
          : 'patient_inventory';

      final querySnapshot = await _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId.value)
          .where("medicineId", isEqualTo: medicineId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final currentStock = doc['stock'] ?? 0;

        if (currentStock >= quantity) {
          await doc.reference.update({'stock': currentStock - quantity});
          return true;
        } else {
          return false; // Not enough stock
        }
      }
      return false; // Medicine not found
    } catch (e) {
      _handleError("Failed to deduct stock", e);
      return false;
    }
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
