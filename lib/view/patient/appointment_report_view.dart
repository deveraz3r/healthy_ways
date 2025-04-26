import 'package:healty_ways/utils/app_urls.dart';

class AppointmentReportView extends StatelessWidget {
  final String report = Get.arguments;

  AppointmentReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ('Appointment Report'),
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(report, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
