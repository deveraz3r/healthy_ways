import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/assigned_medication_model.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatelessWidget {
  final AssignedMedicationModel assignedMedication;
  final VoidCallback onToggle;

  const MedicationCard({
    super.key,
    required this.assignedMedication,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat('h:mm a').format(assignedMedication.assignedTime);
    String status = assignedMedication.isTaken ? 'Taken' : 'Pending';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              assignedMedication.medicineName,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${assignedMedication.medicineFormula} ${assignedMedication.medicineStockType}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: Colors.black.withOpacity(0.7)),
                const SizedBox(width: 5),
                Text(
                  formattedTime,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.7)),
                )
              ],
            ),
            const Divider(),
            InkWell(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: status == 'Taken'
                      ? AppColors.greenColor
                      : AppColors.redColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
