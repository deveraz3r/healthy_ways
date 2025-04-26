import 'package:healty_ways/utils/app_urls.dart';

class DoctorImmunizationView extends StatelessWidget {
  DoctorImmunizationView({super.key});

  final HealthRecordsViewModel _healthRecordVM = Get.find();

  final String patientId = Get.arguments['patientId'];
  final String patientName = Get.arguments['patientName'] ?? "Patient";

  @override
  Widget build(BuildContext context) {
    // Fetch immunization records for the selected patient
    _healthRecordVM.fetchPatientRecords(patientId);

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "$patientName's Immunizations",
        enableBack: true,
      ),
      body: Obx(() {
        return _healthRecordVM.immunizations.isEmpty
            ? const Center(child: Text("No Immunizations Found"))
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: _healthRecordVM.immunizations.length,
                itemBuilder: (context, index) {
                  return ImmunizationCard(
                    immunization: _healthRecordVM.immunizations[index],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              );
      }),
    );
  }
}
