import 'package:healty_ways/utils/app_urls.dart';

class LabReportCard extends StatelessWidget {
  final LabReportModel report;

  const LabReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blue),
        title: Text(report.testName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${report.status.name}"),
            Text("Uploaded on: ${DateFormat.yMd().format(report.date)}"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to Lab Report Details View
          Get.toNamed(RouteName.labReportDetailsView, arguments: report);
        },
      ),
    );
  }
}
