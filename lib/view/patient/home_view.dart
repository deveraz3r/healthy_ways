import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/assigned_medication_model.dart';
import 'package:healty_ways/model/diary_entry_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/resources/components/shared/home_button.dart';
import 'package:healty_ways/resources/components/patient/medication_card.dart';
import 'package:healty_ways/resources/components/shared/reusable_user_profile_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:healty_ways/view_model/assigned_medication_view_model.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';
import 'package:healty_ways/view_model/doctors_view_model.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';
import 'package:healty_ways/resources/components/patient/build_calendar.dart';

class HomeView extends StatelessWidget {
  final MedicineViewModel _medicineVM = Get.put(MedicineViewModel());
  final AssignedMedicationViewModel _assignedMedicationVM =
      Get.put(AssignedMedicationViewModel());
  final ProfileViewModel _profileVM = Get.put(ProfileViewModel());
  final DoctorsViewModel _doctorsVM = Get.put(DoctorsViewModel());
  final AppointmentsViewModel _appointmentsVM =
      Get.put(AppointmentsViewModel());
  final HealthRecordsViewModel _healthRecordsVM =
      Get.put(HealthRecordsViewModel());
  final InventoryViewModel _inventoryVM = Get.put(InventoryViewModel());
  final OrderViewModel _orderVM = Get.put(OrderViewModel());

  @override
  void initState() {
    // super.initState();
    // _assignedMedicationVM.fetchAssignedMedication(_profileVM.profile!.uid);
    _inventoryVM.initUser();
    _inventoryVM.fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        appBarTitle: ReusableUserProfileCard(),
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
                  _assignedMedicationVM
                      .updateSelectedDate(date); // Update selected date
                },
              ),
              const SizedBox(height: 10),
              _buildGridButtons(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  final selectedDate = _assignedMedicationVM.selectedDate.value;
                  final isToday = selectedDate.year == DateTime.now().year &&
                      selectedDate.month == DateTime.now().month &&
                      selectedDate.day == DateTime.now().day;

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
          title: 'Orders',
          onTap: () async {
            await _medicineVM.fetchAllMedicines();
            String? patientid = Get.find<AuthViewModel>().user?.uid;
            await _orderVM.fetchUserOrders(patientid!, true);
            Get.toNamed(RouteName.patientOrdersView);
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
          color: AppColors.redColor,
        ),
        HomeButton(
          title: 'Diary Entries',
          onTap: () {
            Get.toNamed(
              RouteName.diaryEnteryView,
              arguments: {
                "profile": _profileVM.profile!,
                "acessedBy": UserRole.patient,
              },
            );
          },
          color: AppColors.orangeColor,
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
        HomeButton(
          title: 'Immunization',
          onTap: () {
            Get.toNamed(RouteName.patientImmunizationView);
          },
          color: AppColors.primaryColor,
        ),
        HomeButton(
          title: 'Allergies',
          onTap: () {
            Get.toNamed(RouteName.patientAllergyView);
          },
          color: AppColors.redColor,
        ),
      ],
    );
  }

  Widget _buildMedicationGrid() {
    return Obx(() {
      final medications = _assignedMedicationVM
          .getMedicationsForDate(_assignedMedicationVM.selectedDate.value);

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.25,
        children: medications
            .map((am) => MedicationCard(
                  assignedMedication: AssignedMedicationModel(
                      medication: am,
                      medicine:
                          _assignedMedicationVM.getMedicine(am.medicineId)),
                  onToggle: () => _assignedMedicationVM.markAsTaken(
                    am.id,
                  ), // Toggle medication status
                ))
            .toList(),
      );
    });
  }
}
