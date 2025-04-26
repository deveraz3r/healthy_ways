import 'package:healty_ways/view_model/lab_reports_view_model.dart';
import 'package:healty_ways/resources/components/shared/lab_report_card.dart';

import '../../utils/app_urls.dart';

class LabReportsListView extends StatelessWidget {
  final LabReportsViewModel labReportsVM = Get.put(LabReportsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Reports"),
      ),
      body: Obx(() {
        final groupedReports = labReportsVM.getReportsGroupedByDate();

        if (groupedReports.isEmpty) {
          return const Center(child: Text("No lab reports found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groupedReports.keys.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final date = groupedReports.keys.elementAt(index);
            final reports = groupedReports[date]!;

            return _buildDateGroup(context, date, reports);
          },
        );
      }),
    );
  }

  Widget _buildDateGroup(
      BuildContext context, DateTime date, List<LabReportModel> reports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Text(
          DateFormat('EEEE, MMM d, yyyy').format(date),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Reports List
        ...reports.map((report) => LabReportCard(report: report)),
      ],
    );
  }
}
