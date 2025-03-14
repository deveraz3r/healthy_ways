import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDoctorDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details',
            style:
                GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Dr Joe',
              style: GoogleFonts.manrope(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoTile('Qualification', 'MBBS'),
                _infoTile('Location', 'California'),
                _infoTile('Timing', 'Mon-Tue'),
              ],
            ),
            SizedBox(height: 20),
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
              "I am Dr Joe, a renowned psychiatrist. Looking forward to serving my patients. Book an appointment now to get a seamless recovery experience.",
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.black),
              title: Text('Consultation Hours',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
              subtitle: Text('9am - 6pm', style: GoogleFonts.manrope()),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
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
