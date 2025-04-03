import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view/patient/patient_book_appointment.dart';

class BookDoctorDetailsView extends StatelessWidget {
  const BookDoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed doctor object with error handling
    final DoctorModel? doctor =
        Get.arguments is DoctorModel ? Get.arguments as DoctorModel : null;

    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Doctor information not available')),
      );
    }

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Book Appointment',
        centerTitle: true,
        enableBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor Profile Photo with fallback
              CircleAvatar(
                radius: 50,
                backgroundImage: doctor.profileImage != null
                    ? NetworkImage(doctor.profileImage!)
                    : const AssetImage('assets/images/default_doctor.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 10),
              // Doctor Name
              Text(
                doctor.fullName,
                style: GoogleFonts.manrope(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Doctor Info (Qualification, Specialty, Rating)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoTile('Qualification', doctor.qualification),
                  _infoTile('Specialty', doctor.specialty),
                  _infoTile('Rating', _calculateAverageRating(doctor.ratings)),
                ],
              ),
              const SizedBox(height: 20),
              // About Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  style: GoogleFonts.manrope(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                doctor.bio ??
                    "I am ${doctor.fullName}, a ${doctor.specialty} specialist. Looking forward to serving my patients.",
                style:
                    GoogleFonts.manrope(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              // Consultation Hours
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Consultation Hours',
                  style: GoogleFonts.manrope(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              // Display doctor's available times for each day
              for (var day in doctor.weeklySchedule.keys)
                buildDayCard(day, doctor.weeklySchedule[day]!),
              const SizedBox(height: 20),
              // Book Appointment Button
              ReuseableElevatedbutton(
                buttonName: "Book Appointment",
                onPressed: () => Get.to(
                  PatientBookAppointmentView(doctor: doctor),
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.teal,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //     ),
              //     onPressed: () {
              //       // Add the functionality to book appointment
              //     },
              //     child: Text(
              //       'Book Appointment',
              //       style: GoogleFonts.manrope(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
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
        const SizedBox(height: 4),
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

  // Build a card for each day
  Widget buildDayCard(String day, List<AppointmentSlot> slots) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          ListTile(
            title:
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          for (var slot in slots)
            ListTile(
              title: Text(
                  "${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}"),
            ),
        ],
      ),
    );
  }

  // Format time for display (12-hour format with AM/PM)
  String _formatTime(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }
}
