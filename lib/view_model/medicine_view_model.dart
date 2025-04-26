import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/utils/app_urls.dart';

class MedicineViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<MedicineModel> allMedicines = <MedicineModel>[].obs;
  final RxList<MedicineModel> filteredMedicines = <MedicineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMedicines();
  }

  // Fetch all medicines from Firestore
  Future<void> fetchAllMedicines() async {
    try {
      final querySnapshot = await _firestore.collection('medicines').get();

      final medicines = querySnapshot.docs
          .map((doc) => MedicineModel.fromJson(doc.data()))
          .toList();

      allMedicines.assignAll(medicines);

      // Initially, set the filtered list as the same as the original list
      filteredMedicines.assignAll(allMedicines);
    } catch (e) {
      _handleError('Failed to fetch medicines', e);
    }
  }

  // Add medicine
  Future<void> addMedicine(MedicineModel medicine) async {
    // Generate a unique document ID
    final docRef = _firestore.collection('medicines').doc();
    final uniqueId = docRef.id;

    final newMedicine = medicine.copyWith(id: uniqueId);

    try {
      await _firestore.collection('medicines').add(newMedicine.toJson());

      //update locally aswell
      allMedicines.add(newMedicine);
      filteredMedicines.add(newMedicine);
    } catch (e) {
      _handleError('Failed to add medicine', e);
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

      // Remove from local list as well
      allMedicines.removeWhere((m) => m.id == medicine.id);
      filteredMedicines.removeWhere((m) => m.id == medicine.id);
    } catch (e) {
      _handleError('Failed to delete medicine', e);
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
        filteredMedicines[index] = medicine;

        // Refresh the lists to update the UI
        allMedicines.refresh();
        filteredMedicines.refresh();
      }
    } catch (e) {
      _handleError('Failed to update medicine', e);
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

  String getMedicineNameById(String id) {
    try {
      return allMedicines.firstWhere((med) => med.id == id).name;
    } catch (_) {
      return 'Unknown Medicine';
    }
  }

  _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
