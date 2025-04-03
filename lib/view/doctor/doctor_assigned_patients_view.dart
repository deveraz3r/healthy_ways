import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/components/doctor/doctor_assigned_patient_tile.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/patients_view_model.dart';

class DoctorAssignedPatientsView extends StatelessWidget {
  final PatientsViewModel controller = Get.put(PatientsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Assigned Patients",
        enableBack: true,
      ),
      body: Obx(() {
        if (controller.patients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.3, // Makes the logo greyish
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100, // Adjust the size as needed
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No patients assigned",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.patients.length,
          itemBuilder: (context, index) {
            final patient = controller.patients[index];
            return DoctorAssignedPatientTile(
              name: patient.fullName,
              email: patient.email,
              uid: patient.uid,
            );
          },
        );
      }),
    );
  }
}
