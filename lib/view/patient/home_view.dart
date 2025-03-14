import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/components/build_calendar.dart';
import 'package:healty_ways/resources/components/home_button.dart';
import 'package:healty_ways/resources/components/medication_card.dart';
import 'package:healty_ways/utils/app_urls.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/profile_pic.png',
                    ), // Add your image path
                    radius: 20,
                  ),
                  const SizedBox(width: 12), // Spacing between picture and text
                  // Name and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Jane Smith',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Patient',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                      icon: const Icon(Icons.notifications), onPressed: () {})
                ],
              ),
              const SizedBox(height: 10),
              BuildCalendar(),
              const SizedBox(height: 10),
              _buildGridButtons(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Today's Medication",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 10),
              _buildMedicationGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButtons() {
    return GridView.count(
      shrinkWrap: true, // Prevent nested scrolling
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 8, // Horizontal spacing between items
      mainAxisSpacing: 8, // Vertical spacing between items
      childAspectRatio: 4, // Rectangular shape
      padding: EdgeInsets.zero,
      children: [
        HomeButton(
          title: 'Inventory',
          color: AppColors.primaryColor,
          onTap: () {
            Get.toNamed(RouteName.patientInventory);
          },
        ),
        HomeButton(
          title: 'Doctors',
          color: AppColors.blueColor,
          onTap: () {
            Get.toNamed(RouteName.patientBookDoctor);
          },
        ),
        HomeButton(
          title: 'Appointment History',
          color: AppColors.orangeColor,
          onTap: () {
            Get.toNamed(RouteName.patientAppointmentHistory);
          },
        ),
        HomeButton(
          title: 'Medication History',
          color: AppColors.purpleColor,
          onTap: () {
            Get.toNamed(RouteName.patientMedicationsHistory);
          },
        ),
      ],
    );
  }

  Widget _buildMedicationGrid() {
    return GridView.count(
      shrinkWrap: true, // Prevent nested scrolling
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      crossAxisCount: 2, // 2 cards per row
      crossAxisSpacing: 8, // Horizontal spacing between cards
      mainAxisSpacing: 8, // Vertical spacing between cards
      childAspectRatio: 1.18,
      children: const [
        MedicationCard(
          status: 'Taken',
          medicationName: 'Panadol Extra',
          dosage: '2 Tabs',
          doctorName: 'Dr Alex',
          time: '8:30 am',
        ),
        MedicationCard(
          status: 'Pending',
          medicationName: 'Paracetamol',
          dosage: '1 Tab',
          doctorName: 'Dr Smith',
          time: '1:30 pm',
        ),
        MedicationCard(
          status: 'Taken',
          medicationName: 'Ibuprofen',
          dosage: '1 Tab',
          doctorName: 'Dr Jane',
          time: '10:00 am',
        ),
        MedicationCard(
          status: 'Pending',
          medicationName: 'Aspirin',
          dosage: '1 Tab',
          doctorName: 'Dr John',
          time: '3:00 pm',
        ),
        MedicationCard(
          status: 'Pending',
          medicationName: 'Aspirin',
          dosage: '1 Tab',
          doctorName: 'Dr John',
          time: '3:00 pm',
        ),
        MedicationCard(
          status: 'Pending',
          medicationName: 'Aspirin',
          dosage: '1 Tab',
          doctorName: 'Dr John',
          time: '3:00 pm',
        ),
        MedicationCard(
          status: 'Pending',
          medicationName: 'Aspirin',
          dosage: '1 Tab',
          doctorName: 'Dr John',
          time: '3:00 pm',
        ),
      ],
    );
  }
}
