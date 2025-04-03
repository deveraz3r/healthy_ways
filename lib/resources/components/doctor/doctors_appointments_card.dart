import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:intl/intl.dart';

class DoctorsAppointmentsCard extends StatelessWidget {
  final AppointmentModel appointment;

  const DoctorsAppointmentsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final appointmentVM = Get.find<AppointmentsViewModel>();
    final patient = appointmentVM.getPatientInfo(appointment.patientId);

    final formattedTime = DateFormat('h:mm a').format(appointment.time);
    final timeLeft = appointment.time.difference(DateTime.now()).inMinutes;
    final bool isStartAllowed =
        appointment.status == AppointmentStatus.upcoming &&
            timeLeft <= 10 &&
            timeLeft > 0;

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
            if (isStartAllowed)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ReuseableElevatedbutton(
                  onPressed: () {
                    // TODO: Implement start appointment logic for doctor
                    Get.toNamed(
                      RouteName.doctorAppointmentStartView,
                      arguments: appointment,
                    );
                  },
                  buttonName: ("Start Appointment"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Handle navigation based on appointment status
  void _handleNavigation() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        if (appointment.time.difference(DateTime.now()).inMinutes <= 10) {
          //navigation handled in start button
          // Get.toNamed(RouteName.appointmentStart); // TODO: Add doctor start appointment logic
        }
        break;
      case AppointmentStatus.inProgress:
        // Get.toNamed(RouteName.appointmentStart);
        break;
      case AppointmentStatus.completed:
        Get.toNamed(RouteName.doctorAppointmentHistoryDetailsView);
        break;
      case AppointmentStatus.missed:
        // Do nothing
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
