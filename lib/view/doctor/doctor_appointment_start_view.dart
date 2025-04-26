import 'package:healty_ways/utils/app_urls.dart';

class DoctorAppointmentStartView extends StatelessWidget {
  DoctorAppointmentStartView({super.key}) {
    //TODO: this is not a good practice to initialize view models here, move it
    Get.put(HealthRecordsViewModel());
    Get.put(AssignedMedicationViewModel());
  }

  final PatientsViewModel _patientsVM = Get.find<PatientsViewModel>();
  final ChatViewModel _chatVM = Get.find<ChatViewModel>();
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();
  final AppointmentModel appointment = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final PatientModel? patient =
        _patientsVM.getPatientInfo(appointment.patientId);
    //TODO: if patients data is not loading properly then here could be a possible error

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Appointment",
        enableBack: true,
        actions: [
          IconButton(
              onPressed: () async {
                //start appointment logic here
                final String otherUserId =
                    appointment.patientId == _profileVM.profile!.uid
                        ? appointment.doctorId
                        : appointment.patientId;

                await _chatVM.startAppointmentChat(
                  appointment: appointment,
                  otherUserId: otherUserId,
                );
                Get.toNamed(RouteName.chatView);
              },
              icon: Icon(
                Icons.chat,
                color: Colors.white,
              ))
        ],
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
        _patientsVM.getPatientInfo(appointment.patientId);

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
