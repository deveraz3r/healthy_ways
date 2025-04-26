import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/resources/components/patient/patient_appointment_card.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';

class PatientAppointmentHistoryView extends StatefulWidget {
  const PatientAppointmentHistoryView({Key? key}) : super(key: key);

  @override
  _PatientAppointmentHistoryViewState createState() =>
      _PatientAppointmentHistoryViewState();
}

class _PatientAppointmentHistoryViewState
    extends State<PatientAppointmentHistoryView> {
  final AppointmentsViewModel appointmentVM = Get.find<AppointmentsViewModel>();
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() async {
    if (profileVM.profile != null && appointmentVM.isInitial.value) {
      await appointmentVM.fetchUserAppointments(profileVM.profile!.uid, false);
    }
  }

  Future<void> _refreshAppointments() async {
    await appointmentVM.fetchUserAppointments(
      profileVM.profile!.uid,
      profileVM.isDoctor,
    );
    setState(() {}); // Force UI update after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Appointments',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: _refreshAppointments,
          child: appointmentVM.appointments.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 100),
                    Center(
                      child: Text('No appointments found'),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointmentVM.getAppointmentsByDate().keys.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final sortedDates = appointmentVM
                        .getAppointmentsByDate()
                        .keys
                        .toList()
                      ..sort((a, b) => b.compareTo(a));
                    final date = sortedDates[index];
                    final appointments =
                        appointmentVM.getAppointmentsByDate()[date]!;

                    return _buildDateGroup(context, date, appointments);
                  },
                ),
        );
      }),
    );
  }

  Widget _buildDateGroup(BuildContext context, DateTime date,
      List<AppointmentModel> appointments) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Card
        Container(
          width: 45,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                DateFormat('MMM').format(date),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Appointments Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              ...appointments.map((appointment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: PatientAppointmentCard(appointment: appointment),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
