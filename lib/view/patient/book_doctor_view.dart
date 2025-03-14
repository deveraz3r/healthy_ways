import 'package:healty_ways/utils/app_urls.dart';

class BookDoctorView extends StatelessWidget {
  const BookDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Doctors",
        enableBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DoctorCard(
            name: 'Dr John',
            profilePhoto: "assets/images/profile.jpg",
            rating: '★★★★★',
            specialty: 'Psychiatrist | MBBS',
          ),
          SizedBox(height: 16),
          DoctorCard(
            name: 'Dr John',
            profilePhoto: "assets/images/profile.jpg",
            rating: '★★★★★',
            specialty: 'Psychiatrist | MBBS',
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String profilePhoto;
  final String rating;
  final String specialty;

  const DoctorCard({
    super.key,
    required this.name,
    required this.profilePhoto,
    required this.rating,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Profile Photo (Circular)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Name and Rating
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Specialty
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Book Appointment Button
                  ReuseableElevatedbutton(
                    buttonName: "Book Appointment",
                    onPressed: () {
                      Get.toNamed(RouteName.patientBookDoctorDetails);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
