import 'package:healty_ways/resources/components/patient/doctor_card.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/patient/doctors_view_model.dart';

class BookDoctorView extends StatelessWidget {
  const BookDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorViewModel doctorViewModel = Get.put(DoctorViewModel());
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Doctors",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ReusableTextField(
              borderRadius: 10,
              hintText: 'Search by name or specialty...',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          // List of Doctors
          Expanded(
            child: Obx(() {
              // Filter doctors based on the search query
              final filteredDoctors = doctorViewModel.doctors
                  .where((doctor) =>
                      doctor.name.toLowerCase().contains(
                          doctorViewModel.searchQuery.value.toLowerCase()) ||
                      doctor.specialty.toLowerCase().contains(
                          doctorViewModel.searchQuery.value.toLowerCase()))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                children: filteredDoctors.map((doctor) {
                  return Column(
                    children: [
                      DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          // Navigate to details view with the selected doctor
                          Get.toNamed(
                            RouteName.patientBookDoctorDetails,
                            arguments: doctor, // Pass the doctor object
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
