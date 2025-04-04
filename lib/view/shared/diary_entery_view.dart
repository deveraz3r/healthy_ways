import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/diary_entry_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/resources/components/shared/diary_entry_card.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class DiaryEnteryView extends StatelessWidget {
  DiaryEnteryView({super.key});

  final UserModel profile = Get.arguments["profile"];
  final UserRole accessedBy = Get.arguments["acessedBy"];

  final HealthRecordsViewModel _healthRecordsVM =
      Get.put(HealthRecordsViewModel());

  @override
  Widget build(BuildContext context) {
    // Fetch entries on build (you may move this to initState in StatefulWidget for optimization)
    _healthRecordsVM.fetchDiaryEnteries(profile.uid, profile.role);

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ("Diary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddEntryDialog(context);
            },
          )
        ],
        enableBack: true,
      ),
      body: Obx(() {
        final entries = _healthRecordsVM.diaryEntries;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: entries.isEmpty
                ? const Center(child: Text("No Diary Entries available"))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return DiaryEntryCard(
                        entry: entries[index],
                        accessedBy: accessedBy,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
          ),
        );
      }),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final profileVM = Get.find<ProfileViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Diary Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: "Body"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  bodyController.text.trim().isEmpty) return;

              final diary = DiaryEntryModel(
                id: '', // will be auto-filled after _getNextHexId
                patientId: profile.uid,
                doctorId: accessedBy == UserRole.doctor
                    ? profileVM.profile?.uid
                    : null,
                pharmacistId: accessedBy == UserRole.pharmacist
                    ? profileVM.profile?.uid
                    : null,
                addedBy: accessedBy,
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
                lastEdited: DateTime.now(),
              );

              await _healthRecordsVM.addDiaryEntry(diary);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
