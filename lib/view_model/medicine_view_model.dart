import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/medicine_model.dart';

class MedicineViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<MedicineModel> allMedicines = <MedicineModel>[].obs;
  final RxList<MedicineModel> filteredMedicines = <MedicineModel>[].obs;

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

  // Fetch all medicines from Firestore
  Future<void> fetchAllMedicines() async {
    try {
      final querySnapshot = await _firestore.collection('medicines').get();

      final medicines = querySnapshot.docs
          .map((doc) => MedicineModel.fromJson(doc.data()..['id'] = doc['id']))
          .toList();

      print('Found ${querySnapshot.docs.length} medicine documents');

      allMedicines.assignAll(medicines);

      // Initially, set the filtered list as the same as the original list
      filteredMedicines.assignAll(allMedicines);

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
      filteredMedicines.add(newMedicine); // Add to the filtered list as well
    } catch (e) {
      print('Error adding medicine: $e');
    }
  }

  // Delete medicine by custom ID
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
      filteredMedicines.removeWhere(
          (m) => m.id == medicine.id); // Remove from filtered list as well
    } catch (e) {
      print('Error deleting medicine: $e');
    }
  }

  // Update medicine by custom ID
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
        filteredMedicines[index] = medicine; // Update filtered list as well
        allMedicines.refresh();
        filteredMedicines.refresh();
      }
    } catch (e) {
      print('Error updating medicine: $e');
    }
  }

  // Get a medicine by ID from the loaded list
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

  // Filter medicines based on search term (from already loaded list)
  void filterMedicines(String searchTerm) {
    if (searchTerm.isEmpty) {
      // If the search term is empty, show all medicines
      filteredMedicines.assignAll(allMedicines);
    } else {
      // Filter the medicines list based on the name (case-insensitive)
      filteredMedicines.assignAll(allMedicines.where((medicine) {
        return medicine.name.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList());
    }
  }

  // Fetch medicines by search term from Firestore (if needed)
  Future<void> fetchAllMedicinesBySearch(String searchTerm) async {
    try {
      final querySnapshot = await _firestore
          .collection('medicines')
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      final medicines = querySnapshot.docs
          .map((doc) => MedicineModel.fromJson(doc.data()..['id'] = doc['id']))
          .toList();

      allMedicines.assignAll(medicines);
      filteredMedicines.assignAll(medicines);
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

  String getMedicineNameById(String id) {
    try {
      return allMedicines.firstWhere((med) => med.id == id).name;
    } catch (_) {
      return 'Unknown Medicine';
    }
  }
}
