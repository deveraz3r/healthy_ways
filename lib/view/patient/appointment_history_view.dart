import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/components/reusable_app_bar.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:intl/intl.dart';

// Model
class MedicationSchedule {
  final DateTime date;
  final List<MedicationEntry> medications;
  final String dayAbbreviation;
  final String monthAbbreviation;

  MedicationSchedule({
    required this.date,
    required this.medications,
    required this.dayAbbreviation,
    required this.monthAbbreviation,
  });
}

class MedicationEntry {
  final String name;
  final TimeOfDay time;
  final String status;
  final bool isTaken;

  MedicationEntry({
    required this.name,
    required this.time,
    required this.status,
    required this.isTaken,
  });
}

// View
class AppointmentHistoryView extends StatelessWidget {
  AppointmentHistoryView({super.key});

  final scheduleData = [
    MedicationSchedule(
      date: DateTime(2023, 7, 29),
      dayAbbreviation: '29',
      monthAbbreviation: 'Jul',
      medications: [
        MedicationEntry(
          name: 'Panadol',
          time: TimeOfDay(hour: 8, minute: 0),
          status: 'Missed',
          isTaken: false,
        ),
        MedicationEntry(
          name: 'Paracetamol',
          time: TimeOfDay(hour: 13, minute: 0),
          status: 'Missed',
          isTaken: false,
        ),
      ],
    ),
    MedicationSchedule(
      date: DateTime(2023, 7, 30),
      dayAbbreviation: '30',
      monthAbbreviation: 'Jul',
      medications: [
        MedicationEntry(
          name: 'Panadol',
          time: TimeOfDay(hour: 8, minute: 0),
          status: 'Taken',
          isTaken: true,
        ),
        MedicationEntry(
          name: 'Paracetamol',
          time: TimeOfDay(hour: 13, minute: 0),
          status: 'Taken',
          isTaken: true,
        ),
        MedicationEntry(
          name: 'Dapa',
          time: TimeOfDay(hour: 20, minute: 0),
          status: 'Taken',
          isTaken: true,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Medication History',
        enableBack: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: scheduleData.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final schedule = scheduleData[index];
          return _buildDateGroup(context, schedule);
        },
      ),
    );
  }

  Widget _buildDateGroup(BuildContext context, MedicationSchedule schedule) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Card
        Container(
          width: 45,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                schedule.monthAbbreviation,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                schedule.dayAbbreviation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Medications Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(schedule.date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              ...schedule.medications.map(
                (med) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: DoctorCard(
                    name: "John Doe",
                    profilePhoto: "assets/images/profile.jpg",
                    isTaken: true,
                    specialty: "MBBS",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String profilePhoto;
  final bool isTaken;
  final String specialty;

  const DoctorCard({
    super.key,
    required this.name,
    required this.profilePhoto,
    required this.isTaken,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.patientAppointmentReport);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Profile Photo (Circular)
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                          isTaken ? "Completed" : "Missed",
                          style: TextStyle(
                            color: isTaken ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
