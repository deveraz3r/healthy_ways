import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';

class DoctorsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<DoctorModel> _doctors = <DoctorModel>[].obs;
  final RxString _searchQuery = ''.obs;

  List<DoctorModel> get doctors => _doctors;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }

  Future<void> fetchAllDoctors() async {
    try {
      final query = await _firestore.collection('doctors').get();

      // Type-safe document processing
      _doctors.assignAll(query.docs.map((doc) {
        final data = doc.data();
        return DoctorModel.fromJson(data);
      }).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch doctors: ${e.toString()}");
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
  }

  List<DoctorModel> get filteredDoctors {
    if (_searchQuery.isEmpty) return _doctors;

    return _doctors
        .where((doctor) =>
            doctor.fullName.toLowerCase().contains(_searchQuery.value) ||
            doctor.specialty.toLowerCase().contains(_searchQuery.value) ||
            (doctor.location.toLowerCase().contains(_searchQuery.value)))
        .toList();
  }

  Future<List<DoctorModel>> searchDoctorsFirestore(String query) async {
    if (query.isEmpty) return _doctors;

    try {
      final nameQuery = await _firestore
          .collection('doctors')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final specialtyQuery = await _firestore
          .collection('doctors')
          .where('specialty', isGreaterThanOrEqualTo: query)
          .where('specialty', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final locationQuery = await _firestore
          .collection('doctors')
          .where('location', isGreaterThanOrEqualTo: query)
          .where('location', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Combine and deduplicate with type safety
      final allDocs = [
        ...nameQuery.docs,
        ...specialtyQuery.docs,
        ...locationQuery.docs
      ];

      final uniqueDocs = allDocs
          .fold<Map<String, QueryDocumentSnapshot>>(
              {}, (map, doc) => map..[doc.id] = doc)
          .values
          .toList();

      return uniqueDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Explicit cast
        return DoctorModel.fromJson(data);
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Search failed: ${e.toString()}");
      return [];
    }
  }
}
