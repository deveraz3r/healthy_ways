import 'package:healty_ways/model/shared/appointment.dart'; // Correct import
import 'package:healty_ways/utils/app_urls.dart';
import 'package:intl/intl.dart'; // For time formatting

class DoctorsAppointmentsCard extends StatelessWidget {
  final Appointment appointment;

  DoctorsAppointmentsCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    // Convert DateTime to TimeOfDay
    final timeOfDay = TimeOfDay.fromDateTime(appointment.time);

    // Format time to 12-hour format with AM/PM
    final formattedTime = _formatTime(timeOfDay);

    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.doctorAppointmentHistoryDetailsView);
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
          child: Row(
            children: [
              // Profile Photo (Circular)
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      appointment.profilePhoto ?? "assets/images/profile.jpg",
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
                          appointment.patientEmail.split('@')[0],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          appointment.state.name,
                          style: TextStyle(
                            color: appointment.state ==
                                    AppointmentState.completed
                                ? AppColors.greenColor
                                : appointment.state == AppointmentState.upcoming
                                    ? AppColors.orangeColor
                                    : AppColors.redColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedTime, // Use formatted time
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
        ),
      ),
    );
  }

  // Helper method to format TimeOfDay to 12-hour format with AM/PM
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a')
        .format(dateTime); // Format as 12-hour with AM/PM
  }
}
