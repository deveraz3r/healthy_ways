import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';

class DoctorsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<DoctorModel> _doctors = <DoctorModel>[].obs;

  List<DoctorModel> get doctors => _doctors;

  Future<void> fetchAllDoctors() async {
    final query = await _firestore.collection('doctors').get();
    _doctors.assignAll(
        query.docs.map((doc) => DoctorModel.fromJson(doc.data())).toList());
  }

  Future<List<DoctorModel>> searchDoctors(String specialty) async {
    if (specialty.isEmpty) return _doctors;
    return _doctors
        .where((doctor) =>
            doctor.specialty.toLowerCase().contains(specialty.toLowerCase()))
        .toList();
  }
}
