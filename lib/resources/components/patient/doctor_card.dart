import 'package:healty_ways/utils/app_urls.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  // Calculate average rating from all ratings
  double _calculateAverageRating() {
    if (doctor.ratings.isEmpty) return 0.0;
    final totalStars =
        doctor.ratings.fold(0, (sum, rating) => sum + rating.stars);
    return totalStars / doctor.ratings.length;
  }

  // Helper function to build star rating
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (hasHalfStar && index == fullStars) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = _calculateAverageRating();

    return GestureDetector(
      onTap: onTap,
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
                    image: AssetImage(
                        doctor.profileImage ?? "assets/images/profile.jpg"),
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
                          doctor.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        _buildRatingStars(averageRating),
                        const SizedBox(width: 4),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
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
                      onPressed: onTap,
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
