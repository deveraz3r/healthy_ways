import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/utils/routes/route_name.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:intl/intl.dart';

class PatientAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const PatientAppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentVM = Get.find<AppointmentsViewModel>();
    final doctor = appointmentVM.getDoctorInfo(appointment.doctorId);

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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile Photo (Circular)
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          doctor?.profileImage ?? "assets/images/profile.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Doctor Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Name and Status
                        Row(
                          children: [
                            Text(
                              doctor?.fullName ?? 'Unknown Doctor',
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
                        // Qualification, Specialty, and Time
                        Row(
                          children: [
                            Text(
                              '${doctor?.qualification ?? "MD"} | ${doctor?.specialty ?? "General"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
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
                      // TODO: Implement start appointment logic
                      Get.toNamed(
                        RouteName.patientAppointmentStartView,
                        arguments: appointment,
                      );
                    },
                    buttonName: ("Start Appointment"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle navigation based on appointment status
  void _handleNavigation() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        if (appointment.time.difference(DateTime.now()).inMinutes <= 10) {
          // Get.toNamed(RouteName.appointmentStart); //TODO: Add start appointment
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

  // Helper to get color based on appointment status
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
      default:
        return Colors.grey;
    }
  }
}
