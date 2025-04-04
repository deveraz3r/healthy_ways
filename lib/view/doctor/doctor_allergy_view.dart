import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/patient/allergy_card.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';

class DoctorAllergyView extends StatelessWidget {
  DoctorAllergyView({super.key});

  final HealthRecordsViewModel _healthRecordVM = Get.find();

  final String patientId = Get.arguments['patientId'];
  final String patientName = Get.arguments['patientName'] ?? "Patient";

  @override
  Widget build(BuildContext context) {
    // Fetch the allergies for the specific patient
    _healthRecordVM.fetchPatientRecords(patientId);

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "$patientName's Allergies",
        enableBack: true,
      ),
      body: Obx(() {
        return _healthRecordVM.allergies.isEmpty
            ? const Center(child: Text("No Allergies Found"))
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: _healthRecordVM.allergies.length,
                itemBuilder: (context, index) {
                  return AllergyCard(
                    allergy: _healthRecordVM.allergies[index],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              );
      }),
    );
  }
}
