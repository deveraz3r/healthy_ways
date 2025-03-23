import 'package:healty_ways/resources/components/doctor/assign_medicine_popup.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/doctor/doctor_assigned_patient_details_view_model.dart';

class DoctorAssignedPatientDetailsView extends StatelessWidget {
  final controller = Get.put(DoctorAssignedPatientDetailsViewModel());

  DoctorAssignedPatientDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Patient Details",
        enableBack: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.message, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Patient Profile
            Obx(
              () => Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        controller.profileImage?.value ??
                            "assets/images/profile.jpg"),
                  ),
                  const SizedBox(height: 10),
                  Text(controller.patientName.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(controller.patientType.value,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showAssignMedicinePopup(
                              controller.patientName.value, "Panadol");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text("Update Medicine",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Assign Medicine Button
            // Align(
            //   alignment: Alignment.center,
            //   child: ,
            // ),

            // const SizedBox(height: 20),

            // Medication List
            Expanded(
              child: Obx(
                () => ListView(
                  children: controller.medications.entries.map((entry) {
                    String date = entry.key;
                    List<Medication> meds = entry.value;
                    int total = meds.length;
                    int takenCount = meds.where((m) => m.isTaken).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.greenColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("$takenCount/$total",
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: meds
                                .map((med) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: MedicationCard(medication: med),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({required this.medication, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(medication.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(medication.dosage,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(medication.time, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
              color: medication.isTaken
                  ? AppColors.greenColor
                  : AppColors.redColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              medication.isTaken ? "Taken" : "Missed",
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
