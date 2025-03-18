import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/patient/doctor.dart';

class BookDoctorDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the passed doctor object
    final Doctor doctor = Get.arguments as Doctor;

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
            // Doctor Profile Photo
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(doctor.profilePhoto),
            ),
            SizedBox(height: 10),
            // Doctor Name
            Text(
              doctor.name,
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
                _infoTile('Rating', '${doctor.rating}'),
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
              "I am ${doctor.name}, a renowned ${doctor.specialty}. Looking forward to serving my patients. Book an appointment now to get a seamless recovery experience.",
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
                '9am - 6pm',
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
                  // Handle booking appointment
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
}
