import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/diary_entry_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntryModel entry;
  final UserRole accessedBy;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.accessedBy,
  });

  @override
  Widget build(BuildContext context) {
    final profileVM = Get.find<ProfileViewModel>();
    final healthRecordsVM = Get.find<HealthRecordsViewModel>();
    final currentUserId = profileVM.profile?.uid ?? "";

    // Check if delete icon should show
    final canDelete = entry.patientId == currentUserId ||
        (entry.addedBy == UserRole.doctor && entry.doctorId == currentUserId) ||
        (entry.addedBy == UserRole.pharmacist &&
            entry.pharmacistId == currentUserId);

    String addedByName = '';
    String? addedById;

    switch (entry.addedBy) {
      case UserRole.patient:
        addedByName =
            profileVM.isPatient && profileVM.profile?.uid == entry.patientId
                ? profileVM.profile?.fullName ?? "Patient"
                : "Patient";
        addedById = entry.patientId;
        break;
      case UserRole.doctor:
        addedByName =
            profileVM.isDoctor && profileVM.profile?.uid == entry.doctorId
                ? profileVM.profile?.fullName ?? "Doctor"
                : "Doctor";
        addedById = entry.doctorId;
        break;
      case UserRole.pharmacist:
        addedByName = "Pharmacist";
        addedById = entry.pharmacistId;
        break;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              entry.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// Body
            Text(
              entry.body,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            /// Added By (Name & Role)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$addedByName (${entry.addedBy.value})",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                /// Delete Icon (if applicable)
                if (canDelete)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await healthRecordsVM.deleteDiaryEntery(
                          entry.id, accessedBy);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
