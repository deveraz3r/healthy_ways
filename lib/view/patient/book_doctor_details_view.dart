import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:intl/intl.dart';

class BookDoctorDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the passed doctor object with error handling
    final DoctorModel? doctor =
        Get.arguments is DoctorModel ? Get.arguments as DoctorModel : null;

    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Doctor information not available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Details',
          style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Profile Photo with fallback
            CircleAvatar(
              radius: 50,
              backgroundImage: doctor.profileImage != null
                  ? NetworkImage(doctor.profileImage!)
                  : AssetImage('assets/images/default_doctor.png')
                      as ImageProvider,
            ),
            SizedBox(height: 10),
            // Doctor Name
            Text(
              doctor.fullName,
              style: GoogleFonts.manrope(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Doctor Info (Qualification, Specialty, Rating)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoTile('Qualification', doctor.qualification),
                _infoTile('Specialty', doctor.specialty),
                _infoTile('Rating', _calculateAverageRating(doctor.ratings)),
              ],
            ),
            SizedBox(height: 20),
            // About Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About',
                style: GoogleFonts.manrope(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Text(
              doctor.bio ??
                  "I am ${doctor.fullName}, a ${doctor.specialty} specialist. Looking forward to serving my patients.",
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            // Consultation Hours
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.black),
              title: Text(
                'Consultation Hours',
                style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _formatAvailableTimes(doctor.availableTimes),
                style: GoogleFonts.manrope(),
              ),
            ),
            Spacer(),
            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Get.toNamed(RouteName.patientBookAppointment,
                  //     arguments: doctor);  //TODO: add book appointment
                },
                child: Text(
                  'Book Appointment',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create info tiles
  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Calculate average rating from ratings list
  String _calculateAverageRating(List<RatingModel> ratings) {
    if (ratings.isEmpty) return 'No ratings';
    final average =
        ratings.map((r) => r.stars).reduce((a, b) => a + b) / ratings.length;
    return average.toStringAsFixed(1);
  }

  // Format available times
  String _formatAvailableTimes(List<DateTime> availableTimes) {
    if (availableTimes.isEmpty) return 'Not available';

    final times = availableTimes.map((time) {
      return DateFormat('h:mm a').format(time);
    }).join(', ');

    return 'Available at: $times';
  }
}
