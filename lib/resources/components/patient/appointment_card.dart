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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile Photo
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
                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
              if (showStartButton || showResumeButton)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ReuseableElevatedbutton(
                    onPressed: () async {
                      // ✅ Update status from upcoming → inProgress
                      if (appointment.status == AppointmentStatus.upcoming) {
                        await appointmentVM.updateAppointmentStatus(
                          appointment,
                          AppointmentStatus.inProgress,
                        );
                      }

                      Get.toNamed(
                        RouteName.patientAppointmentStartView,
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
      ),
    );
  }

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
          RouteName.patientAppointmentReport,
          arguments: appointment.report,
        );
        break;
      case AppointmentStatus.missed:
        // No action
        break;
    }
  }

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
