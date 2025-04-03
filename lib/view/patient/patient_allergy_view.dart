import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/patient/allergy_card.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:healty_ways/model/allergy_model.dart';

class PatientAllergyView extends StatelessWidget {
  PatientAllergyView({super.key});

  final HealthRecordsViewModel _healthRecordVM = Get.find();
  final ProfileViewModel _profileVM = Get.find();

  void _showAddAllergyDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text("Add Allergy"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty &&
                  _profileVM.profile != null) {
                AllergyModel newAllergy = AllergyModel(
                  id: "", // Firebase will generate the ID
                  title: titleController.text,
                  description: descController.text,
                  patientId: _profileVM.profile!.uid, // Auto-filled
                );

                await _healthRecordVM.addAllergy(newAllergy);
                Get.back();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Allergies",
        enableBack: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddAllergyDialog(context),
          )
        ],
      ),
      body: Obx(() {
        return _healthRecordVM.allergies.isEmpty
            ? Center(child: Text("No Allergies Found"))
            : ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: _healthRecordVM.allergies.length,
                itemBuilder: (context, index) {
                  return AllergyCard(
                    allergy: _healthRecordVM.allergies[index],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 5),
              );
      }),
    );
  }
}
