import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/resources/components/shared/appointment_profile_card.dart';
import 'package:healty_ways/resources/components/shared/home_button.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:healty_ways/view_model/assigned_medication_view_model.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';

class DoctorAppointmentStartView extends StatelessWidget {
  DoctorAppointmentStartView({super.key});

  final AppointmentsViewModel _appointmentsVm = Get.find();
  final AppointmentModel appointment = Get.arguments;
  final HealthRecordsViewModel _healthRecordsVM =
      Get.put(HealthRecordsViewModel());
  final AssignedMedicationViewModel _assignMedsVM =
      Get.put(AssignedMedicationViewModel());

  @override
  Widget build(BuildContext context) {
    final PatientModel? patient =
        _appointmentsVm.getPatientInfo(appointment.patientId);

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Appointment",
        enableBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              patient != null
                  ? AppointmentProfileCard(profile: patient)
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
              _buildGridButtons(),
              const SizedBox(height: 10),
              const Center(child: Text("Chat box here")),
              ReuseableElevatedbutton(buttonName: "End Appointment")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButtons() {
    final PatientModel? patient =
        _appointmentsVm.getPatientInfo(appointment.patientId);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4,
      padding: EdgeInsets.zero,
      children: [
        HomeButton(
          title: 'Allergies',
          onTap: () {
            Get.toNamed(
              RouteName.doctorAllergyView,
              arguments: {
                "patientId": patient!.uid,
                "patientName": patient!.fullName,
              },
            );
          },
          color: AppColors.orangeColor,
        ),
        HomeButton(
          title: 'Immunization',
          onTap: () {
            Get.toNamed(
              RouteName.doctorImmunizationView,
              arguments: {
                "patientId": patient!.uid,
                "patientName": patient.fullName,
              },
            );
          },
          color: AppColors.primaryColor,
        ),
        HomeButton(
          title: 'Vitals',
          onTap: () {},
          color: AppColors.blueColor,
        ),
        HomeButton(
          title: 'Diary Notes',
          onTap: () {
            Get.toNamed(
              RouteName.diaryEnteryView,
              arguments: {
                "profile": patient!,
                "acessedBy": UserRole.doctor,
              },
            );
          },
          color: AppColors.purpleColor,
        ),
        HomeButton(
          title: 'Lab Reports',
          onTap: () {},
          color: AppColors.redColor,
        ),
        HomeButton(
          title: 'Assign Medicine',
          onTap: () {
            Get.toNamed(
              RouteName.doctorMedicineAssignView,
              arguments: {
                "patientId": patient!.uid,
                "patientName": patient.fullName,
                "appointmentId": appointment.appointmentId,
              },
            );
          },
          color: AppColors.purpleColor,
        ),
      ],
    );
  }
}
