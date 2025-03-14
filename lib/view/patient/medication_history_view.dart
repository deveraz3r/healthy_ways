import 'package:flutter/material.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/components/reusable_app_bar.dart';
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
class MedicationHistoryView extends StatelessWidget {
  MedicationHistoryView({super.key});

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
              ...schedule.medications
                  .map((med) => _buildMedicationItem(context, med)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationItem(
      BuildContext context, MedicationEntry medication) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "# ${medication.name}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                medication.status,
                style: TextStyle(
                  color: medication.isTaken ? Colors.green : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                medication.time.format(context),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
