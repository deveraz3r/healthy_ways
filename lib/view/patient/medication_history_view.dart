import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/assigned_medication_view_model.dart';
import 'package:healty_ways/model/medication_model.dart';

class MedicationHistoryView extends StatelessWidget {
  MedicationHistoryView({super.key});

  final AssignedMedicationViewModel assignedMedicationVM =
      Get.find<AssignedMedicationViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Medication History',
        enableBack: true,
      ),
      body: Obx(() {
        // Get the list of medications for the selected date
        final List<MedicationModel> medications =
            assignedMedicationVM.assignedMedications;

        // Group medications by date
        Map<DateTime, List<MedicationModel>> groupedByDate = {};
        for (var medication in medications) {
          final assignedDate = DateTime(
            medication.assignedTime.year,
            medication.assignedTime.month,
            medication.assignedTime.day,
          );

          // Check if the date is not present in the map
          // If not, initialize it with an empty list
          if (!groupedByDate.containsKey(assignedDate)) {
            groupedByDate[assignedDate] = [];
          }
          groupedByDate[assignedDate]?.add(medication);
        }

        // Display each group of medications by date
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groupedByDate.keys.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final date = groupedByDate.keys.elementAt(index);
            final medicationsForDate = groupedByDate[date]!;

            return _buildDateGroup(context, date, medicationsForDate);
          },
        );
      }),
    );
  }

  Widget _buildDateGroup(
      BuildContext context, DateTime date, List<MedicationModel> medications) {
    final String dayAbbreviation = DateFormat('d').format(date);
    final String monthAbbreviation = DateFormat('MMM').format(date);

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
                monthAbbreviation,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dayAbbreviation,
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
                DateFormat('EEEE').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              // Display medications for the given date
              ...medications.map((med) => _buildMedicationItem(context, med)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationItem(
      BuildContext context, MedicationModel medication) {
    final DateTime assignedTime = medication.assignedTime;
    final TimeOfDay time = TimeOfDay(
      hour: assignedTime.hour,
      minute: assignedTime.minute,
    );

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
                "# ${assignedMedicationVM.getMedicine(medication.medicineId).name}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                medication.isTaken ? "Taken" : "Missed",
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
                DateFormat('yyyy-MM-dd – hh:mm a').format(assignedTime),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCustomButton(
            context,
            (medication.isTaken ? 'Mark as Missed' : 'Mark as Taken'),
            () {
              // Mark as taken or missed
              assignedMedicationVM.markAsTaken(medication.id);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildCustomButton(
    BuildContext context, String text, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      // alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
  );
}
