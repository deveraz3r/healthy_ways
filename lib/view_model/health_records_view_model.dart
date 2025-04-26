import 'package:healty_ways/utils/app_urls.dart';

class HealthRecordsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<AllergyModel> allergies = <AllergyModel>[].obs;
  final RxList<ImmunizationModel> immunizations = <ImmunizationModel>[].obs;
  final RxList<DiaryEntryModel> diaryEntries = <DiaryEntryModel>[].obs;

  //============================= Shared =============================

  Future<void> fetchPatientRecords(String patientId) async {
    try {
      // Fetch allergies
      final allergiesQuery = await _firestore
          .collection('allergies')
          .where('patientId', isEqualTo: patientId)
          .get();

      allergies.assignAll(
        allergiesQuery.docs
            .map((doc) => AllergyModel.fromJson(doc.data()))
            .toList(),
      );

      // Fetch immunizations
      final immunizationsQuery = await _firestore
          .collection('immunizations')
          .where('patientId', isEqualTo: patientId)
          .get();

      immunizations.assignAll(
        immunizationsQuery.docs
            .map((doc) => ImmunizationModel.fromJson(doc.data()))
            .toList(),
      );

      // Fetch diary entries
      final diaryEntriesQuery = await _firestore
          .collection('diary')
          .where("patientId", isEqualTo: patientId)
          .get();

      diaryEntries.assignAll(
        diaryEntriesQuery.docs
            .map((doc) => DiaryEntryModel.fromJson(doc.data()))
            .toList(),
      );
    } catch (e) {
      _handleError("Failed to fetch patient records", e);
    }
  }

  //============================= Allergies =============================

  Future<void> addAllergy(AllergyModel allergy) async {
    try {
      final docRef = _firestore.collection('allergies').doc();
      allergy.id = docRef.id;

      await docRef.set(allergy.toJson());
      allergies.add(allergy.copyWith(id: docRef.id));
    } catch (e) {
      _handleError("Failed to add allergy", e);
    }
  }

  Future<void> deleteAllergy(String id) async {
    try {
      await _firestore.collection('allergies').doc(id).delete();
      allergies.removeWhere((a) => a.id == id);
    } catch (e) {
      _handleError("Failed to delete allergy", e);
    }
  }

  //============================= Immunization =============================

  Future<void> addImmunization(ImmunizationModel immunization) async {
    try {
      final docRef = _firestore.collection('immunizations').doc();
      immunization.id = docRef.id;

      await docRef.set(immunization.toJson());
      immunizations.add(immunization.copyWith(id: docRef.id));
    } catch (e) {
      _handleError("Failed to add immunization", e);
    }
  }

  Future<void> deleteImmunization(String id) async {
    try {
      await _firestore.collection('immunizations').doc(id).delete();
      immunizations.removeWhere((i) => i.id == id);
    } catch (e) {
      _handleError("Failed to delete immunization", e);
    }
  }

  //============================= Diary Entrys =============================

  Future<void> addDiaryEntry(DiaryEntryModel diary) async {
    try {
      final docRef = _firestore.collection('diary').doc();
      diary.id = docRef.id;

      await docRef.set(diary.toJson());
      diaryEntries.add(diary.copyWith(id: docRef.id));
    } catch (e) {
      _handleError("Failed to add diary entry", e);
    }
  }

  Future<void> deleteDiaryEntery(String id, UserRole deletedBy) async {
    try {
      final doc = await _firestore.collection('diary').doc(id).get();

      DiaryEntryModel diaryDoc = DiaryEntryModel.fromJson(doc.data()!);

      if (diaryDoc.addedBy == deletedBy || deletedBy == UserRole.patient) {
        await _firestore.collection('diary').doc(id).delete();
        diaryEntries.removeWhere((i) => i.id == id);

        Get.snackbar(
          "Deletion Success",
          "Diary Entry successfully deleted!",
        );
      } else {
        Get.snackbar(
          "Cannot Delete",
          "You do not have permission to delete this entry. Diary entries can only be deleted by the person who added them or the patient themselves.",
        );
      }
    } catch (e) {
      _handleError("Failed to delete diary entry", e);
    }
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
