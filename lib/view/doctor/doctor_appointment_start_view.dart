import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/components/shared/appointment_profile_card.dart';
import 'package:healty_ways/resources/components/shared/home_button.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';

class DoctorAppointmentStartView extends StatelessWidget {
  DoctorAppointmentStartView({super.key});

  final AppointmentsViewModel _appointmentsVm = Get.find();
  final AppointmentModel appointment = Get.arguments;

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
}

Widget _buildGridButtons() {
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
        onTap: () {},
        color: AppColors.orangeColor,
      ),
      HomeButton(
        title: 'Immunization',
        onTap: () {},
        color: AppColors.primaryColor,
      ),
      HomeButton(
        title: 'Vitals',
        onTap: () {},
        color: AppColors.blueColor,
      ),
      HomeButton(
        title: 'Assign Medicine',
        onTap: () {},
        color: AppColors.purpleColor,
      ),
    ],
  );
}
