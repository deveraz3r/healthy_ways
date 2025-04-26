import 'package:healty_ways/resources/components/patient/medication_card.dart'
    as patient;
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/lab_reports_view_model.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key}) {
    // // Initialize the view models in the correct order
    // Get.put(AuthViewModel()); // Auth must be initialized first
    // Get.put(ProfileViewModel()); // Profile depends on Auth

    // // Initialize independent view models
    // Get.put(MedicineViewModel()); // Independent
    // Get.put(InventoryViewModel()); // Depends on Profile

    // // Initialize user-specific view models
    // Get.put(PatientsViewModel()); // Depends on Profile
    // Get.put(DoctorsViewModel()); // Depends on Profile
    // Get.put(PharmacistsViewModel()); // Depends on Profile
    // // Ensure AssignedMedicationViewModel completes initialization
    // final AssignedMedicationViewModel assignedMedicationVM =
    //     Get.put(AssignedMedicationViewModel());
    // assignedMedicationVM
    //     .fetchAssignedMedication(Get.find<ProfileViewModel>().profile!.uid);

    // // Initialize other dependent view models
    // Get.put(AppointmentsViewModel()); // Independent but after Profile
    // Get.put(ChatViewModel()); // Depends on Profile
    // Get.put(HealthRecordsViewModel()); // Depends on Profile
    // Get.put(OrderViewModel()); // Depends on Profile
    // Get.put(LabReportsViewModel()); // Depends on Profile
  }

  final MedicineViewModel _medicineVM = Get.find<MedicineViewModel>();
  final AssignedMedicationViewModel _assignedMedicationVM =
      Get.find<AssignedMedicationViewModel>();
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();
  final DoctorsViewModel _doctorsVM = Get.find<DoctorsViewModel>();
  final AppointmentsViewModel _appointmentsVM =
      Get.find<AppointmentsViewModel>();
  final HealthRecordsViewModel _healthRecordsVM =
      Get.find<HealthRecordsViewModel>();
  final InventoryViewModel _inventoryVM = Get.find<InventoryViewModel>();
  final OrderViewModel _orderVM = Get.find<OrderViewModel>();
  final PharmacistsViewModel _pharmacistsVM = Get.find<PharmacistsViewModel>();
  // final LabReportsViewModel _labReportsVM = Get.put(LabReportsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        appBarTitle: ReusableUserProfileCard(),
        titleText: "",
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              Get.toNamed(RouteName.oneToOneChatsListView);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildCalendar(
                onDateSelected: (date) {
                  _assignedMedicationVM.updateSelectedDate(date);
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4,
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
            String? patientId = Get.find<AuthViewModel>().user?.uid;
            await _orderVM.fetchUserOrders(patientId!, true);
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
          onTap: () {
            // final LabReportsViewModel _labReportsVM =
            //     Get.put(LabReportsViewModel());

            Get.toNamed(RouteName.labReportsListView);
          },
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
// _assignedMedicationVM.filterMedicationsForDate();  //uncomment if date filtering is not working from changedate function
      final medications = _assignedMedicationVM.filterAssignedMedications;

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.25,
        children: medications
            .map((am) => patient.MedicationCard(
                  assignedMedication: AssignedMedicationModel(
                      medication: am,
                      medicine:
                          _assignedMedicationVM.getMedicine(am.medicineId)),
                  onToggle: () => _assignedMedicationVM.markAsTaken(am.id),
                ))
            .toList(),
      );
    });
  }
}
