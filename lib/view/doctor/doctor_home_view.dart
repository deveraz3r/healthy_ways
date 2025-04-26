import 'package:healty_ways/utils/app_urls.dart';

class DoctorHomeView extends StatelessWidget {
  DoctorHomeView({super.key});

  final ProfileViewModel _profileVM = Get.put(ProfileViewModel());
  final AppointmentsViewModel _appointmentsVM =
      Get.put(AppointmentsViewModel());
  final MedicineViewModel _medicineVM = Get.put(MedicineViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        appBarTitle: ReusableUserProfileCard(),
        titleText: "",
        actions: [
          IconButton(
            onPressed: () {
              Get.put(ChatViewModel());
              Get.toNamed(RouteName.oneToOneChatsListView);
            },
            icon: Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                _buildGridButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridButtons() {
    return GridView.count(
      shrinkWrap: true, // Prevent nested scrolling
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 8, // Horizontal spacing between items
      mainAxisSpacing: 8, // Vertical spacing between items
      childAspectRatio: 4, // Rectangular shape
      padding: EdgeInsets.zero,
      children: [
        HomeButton(
          title: 'Assigned Patients',
          onTap: () {
            Get.toNamed(RouteName.doctorAssignedPatientsView);
          },
          color: AppColors.orangeColor,
        ),
        HomeButton(
          title: 'Appointments',
          onTap: () {
            Get.toNamed(RouteName.doctorAppointmentsView);
          },
          color: AppColors.blueColor,
        ),
        HomeButton(
          title: 'Medicines',
          onTap: () {
            Get.toNamed(RouteName.allMedicinesView);
          },
          color: AppColors.redColor,
        ),
      ],
    );
  }
}
