import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/lab_report_model.dart';

class LabReportDetailsView extends StatelessWidget {
  final LabReportModel report = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.testName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.testName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Status: ${report.status.name}"),
            const SizedBox(height: 8),
            Text("Uploaded on: ${report.date.toLocal()}"),
            const SizedBox(height: 16),
            const Text(
              "Attached Files:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...?report.attachedFiles?.map((file) => ListTile(
                  leading: const Icon(Icons.file_present),
                  title: Text(file),
                  onTap: () {
                    // Placeholder for file opening logic
                    Get.snackbar("File", "Open file: $file");
                  },
                )),
          ],
        ),
      ),
    );
  }
}
