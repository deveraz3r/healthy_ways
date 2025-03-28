import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/allergy_model.dart';
import 'package:healty_ways/model/immunization_model.dart';

class HealthRecordsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AllergyModel> _allergies = <AllergyModel>[].obs;
  final RxList<ImmunizationModel> _immunizations = <ImmunizationModel>[].obs;

  List<AllergyModel> get allergies => _allergies;
  List<ImmunizationModel> get immunizations => _immunizations;

  Future<void> fetchPatientRecords(String patientId) async {
    // Fetch allergies
    final allergiesQuery = await _firestore
        .collection('allergies')
        .where('patientId', isEqualTo: patientId)
        .get();
    _allergies.assignAll(allergiesQuery.docs
        .map((doc) => AllergyModel.fromJson(doc.data()))
        .toList());

    // Fetch immunizations
    final immunizationsQuery = await _firestore
        .collection('immunizations')
        .where('patientId', isEqualTo: patientId)
        .get();
    _immunizations.assignAll(immunizationsQuery.docs
        .map((doc) => ImmunizationModel.fromJson(doc.data()))
        .toList());
  }

  Future<void> addAllergy(AllergyModel allergy) async {
    await _firestore.collection('allergies').add(allergy.toJson());
    _allergies.add(allergy);
  }

  Future<void> addImmunization(ImmunizationModel immunization) async {
    await _firestore.collection('immunizations').add(immunization.toJson());
    _immunizations.add(immunization);
  }
}
