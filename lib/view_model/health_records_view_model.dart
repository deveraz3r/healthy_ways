import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/allergy_model.dart';
import 'package:healty_ways/model/immunization_model.dart';
import 'package:healty_ways/model/diary_entry_model.dart';
import 'package:healty_ways/model/user_model.dart';

class HealthRecordsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AllergyModel> _allergies = <AllergyModel>[].obs;
  final RxList<ImmunizationModel> _immunizations = <ImmunizationModel>[].obs;
  final RxList<DiaryEntryModel> _diaryEntries = <DiaryEntryModel>[].obs;

  List<AllergyModel> get allergies => _allergies;
  List<ImmunizationModel> get immunizations => _immunizations;
  List<DiaryEntryModel> get diaryEntries => _diaryEntries;

  /// **Function to get next available Hex ID**
  Future<String> _getNextHexId(String collectionName) async {
    final query = await _firestore.collection(collectionName).get();
    int maxId = 0;

    for (var doc in query.docs) {
      String id = doc.id;
      try {
        int intValue = int.parse(id, radix: 16);
        if (intValue > maxId) {
          maxId = intValue;
        }
      } catch (e) {
        // Ignore invalid IDs that are not hexadecimal
      }
    }

    int nextId = maxId + 1;
    return nextId.toRadixString(16); // Convert back to hexadecimal
  }

  /// **Fetch patient records**
  Future<void> fetchPatientRecords(String patientId) async {
    // Fetch allergies
    final allergiesQuery = await _firestore
        .collection('allergies')
        .where('patientId', isEqualTo: patientId)
        .get();
    _allergies.assignAll(allergiesQuery.docs
        .map((doc) => AllergyModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList());

    // Fetch immunizations
    final immunizationsQuery = await _firestore
        .collection('immunizations')
        .where('patientId', isEqualTo: patientId)
        .get();
    _immunizations.assignAll(immunizationsQuery.docs
        .map((doc) => ImmunizationModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList());
  }

  Future<void> fetchDiaryEnteries(String uid, UserRole addedBy) async {
    String collection;

    switch (addedBy) {
      case UserRole.patient:
        collection = "patientId";
      case UserRole.doctor:
        collection = "doctorId";
      case UserRole.pharmacist:
        collection = "pharmacistId";
    }

    // Fetch diary entries
    final diaryEntriesQuery = await _firestore
        .collection('diary')
        .where(collection, isEqualTo: uid)
        .get();

    _diaryEntries.assignAll(
      diaryEntriesQuery.docs
          .map((doc) => DiaryEntryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList(),
    );
  }

  /// **Add DiaryEntry with Auto ID**
  Future<void> addDiaryEntry(DiaryEntryModel diary) async {
    String newId = await _getNextHexId('diary');

    diary.id = newId;

    await _firestore.collection('diary').doc(newId).set(diary.toJson());
    _diaryEntries.add(diary.copyWith(id: newId));
  }

  /// **Add Allergy with Auto ID**
  Future<void> addAllergy(AllergyModel allergy) async {
    String newId = await _getNextHexId('allergies');
    await _firestore.collection('allergies').doc(newId).set(allergy.toJson());
    _allergies.add(allergy.copyWith(id: newId));
  }

  /// **Add Immunization with Auto ID**
  Future<void> addImmunization(ImmunizationModel immunization) async {
    String newId = await _getNextHexId('immunizations');
    await _firestore
        .collection('immunizations')
        .doc(newId)
        .set(immunization.toJson());
    _immunizations.add(immunization.copyWith(id: newId));
  }

  /// **Delete Allergy**
  Future<void> deleteAllergy(String id) async {
    await _firestore.collection('allergies').doc(id).delete();
    _allergies.removeWhere((a) => a.id == id);
  }

  /// **Delete Immunization**
  Future<void> deleteImmunization(String id) async {
    await _firestore.collection('immunizations').doc(id).delete();
    _immunizations.removeWhere((i) => i.id == id);
  }

  /// **Delete Diary Enteries**
  Future<void> deleteDiaryEntery(String id, UserRole deletedBy) async {
    final doc = await _firestore.collection('diary').doc(id).get();

    DiaryEntryModel diaryDoc = DiaryEntryModel.fromJson(doc.data()!);

    if (diaryDoc.addedBy == deletedBy || deletedBy == UserRole.patient) {
      await _firestore.collection('diary').doc(id).delete();
      _diaryEntries.removeWhere((i) => i.id == id);

      Get.snackbar(
        "Deletion Success",
        "Diary Entery successfully deleted!",
      );
    } else {
      Get.snackbar(
        "Can not delete",
        "You donot have permission to delete This entery, Diary can only be deleted by the person whom added it or patient themself",
      );
    }
  }
}
