import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/resources/components/patient/appointment_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryView extends StatelessWidget {
  final AppointmentsViewModel appointmentVM = Get.put(AppointmentsViewModel());

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
        if (appointmentVM.appointments.isEmpty) {
          return Center(child: Text('No appointments found'));
        }

        final groupedAppointments = appointmentVM.getAppointmentsByDate();
        final sortedDates = groupedAppointments.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sortedDates.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final appointments = groupedAppointments[date]!;
            return _buildDateGroup(context, date, appointments);
          },
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
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                DateFormat('MMM').format(date),
                style: TextStyle(
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
              ...appointments.map((appointment) {
                final doctor =
                    appointmentVM.getDoctorInfo(appointment.doctorId);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: AppointmentCard(
                    name: doctor?.fullName ?? 'Unknown Doctor',
                    profilePhoto: doctor?.profileImage ??
                        'assets/images/default_doctor.png',
                    state: appointment.status,
                    specialty: doctor?.specialty ?? 'General',
                    qualification: doctor?.qualification ?? 'MD',
                    time: TimeOfDay.fromDateTime(appointment.time),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
