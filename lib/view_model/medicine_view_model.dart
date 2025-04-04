import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/medicine_model.dart';

class MedicineViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<MedicineModel> allMedicines = <MedicineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMedicines(); // Ensure data is fetched when the controller is initialized
  }

  // Fetch all medicines from Firestore
  Future<void> fetchAllMedicines() async {
    try {
      final querySnapshot = await _firestore.collection('medicines').get();
      final medicines = querySnapshot.docs.map((doc) {
        return MedicineModel.fromJson(
          doc.data()..addAll({'id': int.tryParse(doc.id) ?? 0}),
        );
      }).toList();

      allMedicines.assignAll(medicines);
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

  // Get the next available id by finding the maximum id in the Firestore collection
  Future<int> getNextId() async {
    final querySnapshot = await _firestore.collection('medicines').get();
    if (querySnapshot.docs.isEmpty) {
      return 1; // If no medicines exist, start from id 1
    }

    // Find the maximum id by comparing the 'id' field in all documents
    final maxId = querySnapshot.docs
        .map((doc) => int.tryParse(doc['id'].toString()) ?? 0)
        .reduce((a, b) => a > b ? a : b);

    return maxId + 1; // Return the next id
  }

  // Add new medicine to Firestore
  Future<void> addMedicine(MedicineModel medicine) async {
    // Get the next available ID
    final nextId = await getNextId();

    // Create the medicine with the new ID
    final newMedicine = medicine.copyWith(id: nextId);

    try {
      // Add the medicine to Firestore
      await _firestore.collection('medicines').add(newMedicine.toJson());

      // Add the new medicine to the local list
      allMedicines.add(newMedicine);
    } catch (e) {
      print('Error adding medicine: $e');
    }
  }

  // Delete a medicine from Firestore
  Future<void> deleteMedicine(MedicineModel medicine) async {
    try {
      await _firestore
          .collection('medicines')
          .doc(medicine.id.toString())
          .delete();
      allMedicines.remove(medicine); // Remove from the list
    } catch (e) {
      print('Error deleting medicine: $e');
    }
  }

  // Update a medicine in Firestore
  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      await _firestore
          .collection('medicines')
          .doc(medicine.id.toString())
          .update(medicine.toJson());

      // Find and update the medicine in the list
      final index = allMedicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        allMedicines[index] = medicine;
        allMedicines.refresh(); // Refresh to update UI
      }
    } catch (e) {
      print('Error updating medicine: $e');
    }
  }
}
