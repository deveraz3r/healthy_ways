import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/patient/medications.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:intl/intl.dart'; // For date formatting

class MedicationCard extends StatelessWidget {
  final Medications medication; // Use the Medications model
  final VoidCallback onToggle; // Callback for toggling isTaken

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onToggle, // Add callback
  });

  @override
  Widget build(BuildContext context) {
    // Format the DateTime to a readable string
    String formattedTime = DateFormat('h:mm a').format(medication.time);

    // Determine the status based on isTaken
    String status = medication.isTaken ? 'Taken' : 'Pending';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            // Medication Name
            Text(
              medication.medicationName,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // const SizedBox(height: 4),
            // Dosage
            Text(
              '${medication.dosage} ${medication.dosageType}', // Include dosageType
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.black.withOpacity(0.7),
                ),
                const SizedBox(width: 5),
                Text(
                  formattedTime, // Use formatted time
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.7),
                  ),
                )
              ],
            ),
            // const SizedBox(height: 5),
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
