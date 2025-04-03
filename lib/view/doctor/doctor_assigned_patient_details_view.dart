import 'package:healty_ways/model/assigned_medication_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/patients_view_model.dart';
import 'package:intl/intl.dart';

class DoctorAssignedPatientDetailsView extends StatelessWidget {
  final PatientsViewModel patientsVM = Get.find();
  final String patientId;
  final Rx<PatientModel?> patient = Rx<PatientModel?>(null);
  final RxList<AssignedMedicationModel> medications =
      <AssignedMedicationModel>[].obs;
  // final RxString profileImage = RxString(null);
  final RxString patientName = "Loading...".obs;
  final RxString patientEmail = "Loading...".obs;
  final RxString profileImage = "assets/images/profile.jpg".obs;

  DoctorAssignedPatientDetailsView({super.key, required this.patientId}) {
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final patientData = await patientsVM.getPatientDetails(patientId);
    if (patientData != null) {
      patient.value = patientData;
      patientName.value = patientData.fullName;
      patientEmail.value = patientData.email;
      profileImage.value =
          patientData.profileImage ?? "assets/images/profile.jpg";
      // Load medications - you'll need to implement this based on your data structure
      // medications.assignAll(await _loadPatientMedications(patientId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Patient Details",
        enableBack: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: IconButton(
              onPressed: () {
                // Implement message functionality
              },
              icon: const Icon(Icons.message, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Patient Profile Section
                _buildPatientProfileSection(),
                const SizedBox(height: 20),

                // Medication List Section
                Expanded(
                  child: _buildMedicationListView(),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildPatientProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(
            profileImage.value,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          patientName.value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          patientEmail.value,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            //TODO: add update med page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            "Update Medicine",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationListView() {
    if (medications.isEmpty) {
      return const Center(
        child: Text("No medications assigned yet"),
      );
    }

    // Group medications by date
    final groupedMeds = <String, List<AssignedMedicationModel>>{};
    for (var med in medications) {
      final date = DateFormat('MMM d, y').format(med.assignedTime);
      groupedMeds.putIfAbsent(date, () => []).add(med);
    }

    return ListView(
      children: groupedMeds.entries.map((entry) {
        final date = entry.key;
        final meds = entry.value;
        final total = meds.length;
        final takenCount = meds.where((m) => m.isTaken).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header with Count
            _buildDateHeader(date, takenCount, total),
            const SizedBox(height: 10),

            // Horizontal Scroll of Medication Cards
            _buildMedicationCards(meds),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDateHeader(String date, int takenCount, int total) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
        const SizedBox(width: 5),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$takenCount/$total",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationCards(List<AssignedMedicationModel> meds) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: meds
            .map((med) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: MedicationCard(assignedMedication: med),
                ))
            .toList(),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final AssignedMedicationModel assignedMedication;

  const MedicationCard({required this.assignedMedication, super.key});

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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Name
          Text(
            assignedMedication.medicineName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),

          // Medicine Formula
          Text(
            assignedMedication.medicineFormula,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),

          // Assigned Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                DateFormat('h:mm a').format(assignedMedication.assignedTime),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
              color: assignedMedication.isTaken
                  ? AppColors.greenColor
                  : AppColors.redColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              assignedMedication.isTaken ? "Taken" : "Missed",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
