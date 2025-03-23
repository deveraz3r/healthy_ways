import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/utils/app_urls.dart';

class DoctorAssignedPatientTile extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const DoctorAssignedPatientTile({
    required this.name,
    required this.email,
    this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Get.toNamed(RouteName.doctorAssignedPatientDetailsView);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    AssetImage(imageUrl ?? "assets/images/profile.jpg"),
              ),
              const SizedBox(width: 12), // Spacing between image and text
              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4), // Spacing between name and email
                    // Email
                    Text(
                      "$email@gmail.com",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
