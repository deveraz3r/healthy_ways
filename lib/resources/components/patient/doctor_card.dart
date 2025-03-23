import 'package:healty_ways/model/patient/doctor.dart';
import 'package:healty_ways/utils/app_urls.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  // Helper function to build star rating
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (hasHalfStar && index == fullStars) {
          return Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback
      child: Card(
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
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(doctor.profilePhoto),
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
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        _buildRatingStars(doctor.rating),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Qualification and Specialty in a Row
                    Text(
                      "${doctor.qualification} | ${doctor.specialty}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Book Appointment Button
                    ReuseableElevatedbutton(
                      buttonName: "Book Appointment",
                      onPressed: onTap, // Use the same onTap callback
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
