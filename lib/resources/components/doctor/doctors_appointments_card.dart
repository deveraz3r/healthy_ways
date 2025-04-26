import 'package:healty_ways/utils/app_urls.dart';

class DoctorsAppointmentsCard extends StatelessWidget {
  final AppointmentModel appointment;

  const DoctorsAppointmentsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final appointmentVM = Get.find<AppointmentsViewModel>();
    final patient =
        Get.find<PatientsViewModel>().getPatientInfo(appointment.patientId);

    final formattedTime = DateFormat('h:mm a').format(appointment.time);
    final timeDiff = DateTime.now().difference(appointment.time);
    final timeDiffMinutes = timeDiff.inMinutes;

    final bool withinStartWindow =
        timeDiffMinutes >= -10 && timeDiffMinutes <= 30;

    final bool showStartButton =
        appointment.status == AppointmentStatus.upcoming && withinStartWindow;
    final bool showResumeButton =
        appointment.status == AppointmentStatus.inProgress && withinStartWindow;

    return InkWell(
      onTap: () {
        _handleNavigation();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              blurRadius: 1,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                // Patient Profile Photo
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        patient?.profileImage ?? "assets/images/profile.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Patient Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Name and Status
                      Row(
                        children: [
                          Text(
                            patient?.fullName ?? 'Unknown Patient',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            appointment.status.name,
                            style: TextStyle(
                              color: _getStatusColor(appointment.status),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Buttons for start or resume appointment
            if (showStartButton || showResumeButton)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ReuseableElevatedbutton(
                  onPressed: () async {
                    // Update status from upcoming → inProgress for doctors
                    if (appointment.status == AppointmentStatus.upcoming) {
                      await appointmentVM.updateAppointmentStatus(
                        appointment,
                        AppointmentStatus.inProgress,
                      );
                    }

                    await Get.find<ChatViewModel>().startAppointmentChat(
                      appointment: appointment,
                      otherUserId: appointment.patientId,
                    );

                    Get.toNamed(
                      RouteName.doctorAppointmentStartView,
                      arguments: appointment,
                    );
                  },
                  buttonName: showResumeButton
                      ? "Resume Appointment"
                      : "Start Appointment",
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Handle navigation based on appointment status
  void _handleNavigation() {
    final timeDiffMinutes =
        DateTime.now().difference(appointment.time).inMinutes;
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        if (timeDiffMinutes >= -10 && timeDiffMinutes <= 30) {
          // Will be handled by button
        }
        break;
      case AppointmentStatus.inProgress:
        // Will be handled by resume
        break;
      case AppointmentStatus.completed:
        Get.toNamed(
          RouteName.doctorAppointmentHistoryDetailsView,
          arguments: appointment,
        );
        break;
      case AppointmentStatus.missed:
        // No action
        break;
    }
  }

  // Helper to get status color
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.upcoming:
        return Colors.orange;
      case AppointmentStatus.inProgress:
        return Colors.blue;
      case AppointmentStatus.missed:
        return Colors.red;
    }
  }
}
