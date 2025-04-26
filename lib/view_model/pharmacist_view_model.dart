import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/utils/app_urls.dart';

class PharmacistsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<PharmacistModel> _allPharmacists = <PharmacistModel>[].obs;
  final RxList<PharmacistModel> _filteredPharmacists = <PharmacistModel>[].obs;

  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  List<PharmacistModel> get pharmacists => _filteredPharmacists;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchAllPharmacists();
  }

  Future<void> fetchAllPharmacists() async {
    try {
      _isLoading.value = true;

      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'pharmacist')
          .get();

      _allPharmacists.value = querySnapshot.docs
          .map((doc) => PharmacistModel.fromJson(doc.data()))
          .toList();

      _filteredPharmacists.assignAll(_allPharmacists);
    } catch (e) {
      _handleError("Failed to fetch pharmacists", e);
    } finally {
      _isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      _filteredPharmacists.assignAll(_allPharmacists);
    } else {
      _filteredPharmacists.assignAll(_allPharmacists.where((pharmacist) =>
          pharmacist.fullName.toLowerCase().contains(query) ||
          pharmacist.email.toLowerCase().contains(query)));
    }
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
