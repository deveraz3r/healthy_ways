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

  // Fetch all medicines
  Future<void> fetchAllMedicines() async {
    try {
      final querySnapshot = await _firestore.collection('medicines').get();

      final medicines = querySnapshot.docs
          .map((doc) => MedicineModel.fromJson(doc.data()..['id'] = doc['id']))
          .toList();

      print('Found ${querySnapshot.docs.length} medicine documents');

      allMedicines.assignAll(medicines);

      for (var med in allMedicines) {
        print("Medicine: ${med.id}");
      }
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

// Add medicine
  Future<void> addMedicine(MedicineModel medicine) async {
    final nextId = await getNextId();
    final newMedicine = medicine.copyWith(id: nextId.toString());

    try {
      await _firestore
          .collection('medicines')
          .add(newMedicine.toJson()); // No need to track docId
      allMedicines.add(newMedicine);
    } catch (e) {
      print('Error adding medicine: $e');
    }
  }

// Delete by custom ID
  Future<void> deleteMedicine(MedicineModel medicine) async {
    try {
      final snapshot = await _firestore
          .collection('medicines')
          .where('id', isEqualTo: medicine.id)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('medicines').doc(doc.id).delete();
      }

      allMedicines.removeWhere((m) => m.id == medicine.id);
    } catch (e) {
      print('Error deleting medicine: $e');
    }
  }

// Update by custom ID
  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      final snapshot = await _firestore
          .collection('medicines')
          .where('id', isEqualTo: medicine.id)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore
            .collection('medicines')
            .doc(doc.id)
            .update(medicine.toJson());
      }

      final index = allMedicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        allMedicines[index] = medicine;
        allMedicines.refresh();
      }
    } catch (e) {
      print('Error updating medicine: $e');
    }
  }

  MedicineModel getMedicine(String medicineId) {
    // Find the medicine from the loaded list where the ID matches
    return allMedicines.firstWhere(
      (medicine) => medicine.id == medicineId,
      orElse: () => MedicineModel(
        id: 'default',
        name: 'Unknown',
        formula: '',
        stockType: '',
        // stock: 0,
      ), // Return a default model if not found
    );
  }
}
