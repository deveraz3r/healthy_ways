import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:healty_ways/model/appointment_model.dart";
import "package:healty_ways/model/doctor_model.dart";
import "package:healty_ways/resources/components/shared/appointment_profile_card.dart";
import "package:healty_ways/resources/widgets/reusable_app_bar.dart";
import "package:healty_ways/view_model/appointments_view_model.dart";

class PatientAppointmentStartView extends StatelessWidget {
  PatientAppointmentStartView({super.key});

  final AppointmentModel appointment = Get.arguments;
  final AppointmentsViewModel _appointmentsVM = Get.find();

  @override
  Widget build(BuildContext context) {
    final DoctorModel? doctor =
        _appointmentsVM.getDoctorInfo(appointment.doctorId);
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Appointment",
        enableBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              AppointmentProfileCard(profile: doctor!),
              Text("Chat here")
            ],
          ),
        ),
      ),
    );
  }
}
