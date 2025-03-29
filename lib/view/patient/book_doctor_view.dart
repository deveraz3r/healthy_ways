import 'package:healty_ways/resources/components/patient/doctor_card.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/doctors_view_model.dart';

class BookDoctorView extends StatelessWidget {
  final DoctorsViewModel doctorViewModel = Get.put(DoctorsViewModel());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Doctors",
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ReusableTextField(
              controller: searchController,
              borderRadius: 10,
              hintText: 'Search by name, specialty or location...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorViewModel.updateSearchQuery(value),
            ),
          ),
          // List of Doctors
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                children: doctorViewModel.filteredDoctors.map((doctor) {
                  return Column(
                    children: [
                      DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          Get.toNamed(
                            RouteName.patientBookDoctorDetails,
                            arguments: doctor,
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
