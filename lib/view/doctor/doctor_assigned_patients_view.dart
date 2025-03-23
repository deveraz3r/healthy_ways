import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/doctor/doctor_assigned_patient_tile.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/doctor/assigned_patient_view_model.dart';

class DoctorAssignedPatientsView extends StatelessWidget {
  final PatientViewModel controller = Get.put(PatientViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Assigned Patients",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.patients.length,
            itemBuilder: (context, index) {
              final patient = controller.patients[index];
              return DoctorAssignedPatientTile(
                name: patient.name,
                email: patient.name,
              );
            },
          )),
    );
  }
}
