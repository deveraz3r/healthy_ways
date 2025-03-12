import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/app_colors.dart';

class MedicationCard extends StatelessWidget {
  final String status;
  final String medicationName;
  final String dosage;
  final String doctorName;
  final String time;

  const MedicationCard({
    super.key,
    required this.status,
    required this.medicationName,
    required this.dosage,
    required this.doctorName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
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
              medicationName,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Dosage
            Text(
              dosage,
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
                SizedBox(
                  width: 5,
                ),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Divider(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                  color: status == 'Taken'
                      ? AppColors.greenColor
                      : AppColors.redColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
