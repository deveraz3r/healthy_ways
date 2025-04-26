import 'package:healty_ways/utils/app_urls.dart';

class DoctorAppointmentsView extends StatefulWidget {
  const DoctorAppointmentsView({super.key});

  @override
  _DoctorAppointmentsViewState createState() => _DoctorAppointmentsViewState();
}

class _DoctorAppointmentsViewState extends State<DoctorAppointmentsView> {
  final AppointmentsViewModel appointmentsVM =
      Get.find<AppointmentsViewModel>();
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() async {
    if (profileVM.profile != null && appointmentsVM.isInitial.value) {
      await appointmentsVM.fetchUserAppointments(profileVM.profile!.uid, true);
    }
  }

  Future<void> _refreshAppointments() async {
    await appointmentsVM.fetchUserAppointments(profileVM.profile!.uid, true);
    setState(() {}); // Force UI update after fetching new data
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
        final groupedAppointments = appointmentsVM.getAppointmentsByDate();

        return RefreshIndicator(
          onRefresh: _refreshAppointments,
          child: groupedAppointments.isEmpty
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
                  itemCount: groupedAppointments.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final date = groupedAppointments.keys.elementAt(index);
                    final appointmentsForDate = groupedAppointments[date]!;

                    return _buildDateGroup(context, date, appointmentsForDate);
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
            color: AppColors.primaryColor,
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
              // Appointments are now displayed in descending order (latest first)
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
