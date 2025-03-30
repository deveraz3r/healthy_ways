import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/resources/components/doctor/doctors_appointments_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentsView extends StatelessWidget {
  DoctorAppointmentsView({super.key});

  final AppointmentsViewModel appointmentViewModel =
      Get.put(AppointmentsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Appointments',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        final groupedAppointments =
            appointmentViewModel.getAppointmentsByDate();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groupedAppointments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final date = groupedAppointments.keys.elementAt(index);
            final appointmentsForDate = groupedAppointments[date]!;

            return _buildDateGroup(context, date, appointmentsForDate);
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
                DateFormat('MMM').format(date), // Month abbreviation
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd').format(date), // Day of the month
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
                DateFormat('EEEE').format(date), // Day of the week
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              ...appointments.map(
                (appointment) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: DoctorsAppointmentsCard(
                    appointment: appointment,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
