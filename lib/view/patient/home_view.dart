import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/components/shared/home_button.dart';
import 'package:healty_ways/resources/components/patient/medication_card.dart';
import 'package:healty_ways/resources/components/patient/home_profile_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/patient/medications_view_model.dart';
import 'package:intl/intl.dart';
import 'package:healty_ways/resources/components/patient/build_calendar.dart';

class HomeView extends StatelessWidget {
  final MedicationsViewModel medicationsViewModel =
      Get.put(MedicationsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        appBarTitle: PatientHomeProfileCard(),
        titleText: "",
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
        actions: [
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Navbar(),
              // const SizedBox(height: 10),
              BuildCalendar(
                onDateSelected: (date) {
                  medicationsViewModel
                      .updateSelectedDate(date); // Update selected date
                },
              ),
              const SizedBox(height: 10),
              _buildGridButtons(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  final selectedDate = medicationsViewModel.selectedDate;
                  final isToday =
                      selectedDate.isToday(); // Use the isToday method
                  final formattedDate = DateFormat('MMM dd, yyyy')
                      .format(selectedDate); // Format the date

                  return Text(
                    isToday
                        ? "Today's Medication"
                        : "Medication for $formattedDate",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              _buildMedicationGrid(),
            ],
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
          title: 'Inventory',
          onTap: () {
            Get.toNamed(RouteName.patientInventory);
          },
          color: AppColors.orangeColor,
        ),
        HomeButton(
          title: 'Pharmacy',
          onTap: () {
            Get.toNamed(RouteName.patientPharmacy);
          },
          color: AppColors.primaryColor,
        ),
        HomeButton(
          title: 'Doctors',
          onTap: () {
            Get.toNamed(RouteName.patientBookDoctor);
          },
          color: AppColors.blueColor,
        ),
        HomeButton(
          title: 'Appointments',
          onTap: () {
            Get.toNamed(RouteName.patientAppointmentHistory);
          },
          color: AppColors.purpleColor,
        ),
        HomeButton(
          title: 'Medication Adherence',
          onTap: () {
            Get.toNamed(RouteName.patientMedicationsHistory);
          },
          color: AppColors.orangeColor,
        ),
        HomeButton(
          title: 'Diary Entries',
          onTap: () {},
          color: AppColors.primaryColor,
        ),
        HomeButton(
          title: 'Health Tracker',
          onTap: () {},
          color: AppColors.blueColor,
        ),
        HomeButton(
          title: 'Lab Reports',
          onTap: () {},
          color: AppColors.purpleColor,
        ),
      ],
    );
  }

  Widget _buildMedicationGrid() {
    return Obx(() {
      // Filter medications based on the selected date
      final filteredMedications = medicationsViewModel.medications
          .where((medication) =>
              medication.time.year == medicationsViewModel.selectedDate.year &&
              medication.time.month ==
                  medicationsViewModel.selectedDate.month &&
              medication.time.day == medicationsViewModel.selectedDate.day)
          .toList();

      // Convert filtered medications to MedicationCard widgets
      final medicationCards = filteredMedications
          .map((medication) => MedicationCard(
                medication: medication,
                onToggle: () => medicationsViewModel
                    .toggleMedicationStatus(medication), // Pass toggle callback
              ))
          .toList();

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.25,
        children: medicationCards,
      );
    });
  }
}
