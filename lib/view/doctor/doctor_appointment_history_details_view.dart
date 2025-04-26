import 'package:healty_ways/utils/app_urls.dart';

class DoctorAppointmentHistoryDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: ReusableAppBar(
        titleText: ("Medicine Report"),
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Report Section
            ReportCard(),
          ],
        ),
      ),
    );
  }
}

// Medicine Card Widget
class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String doctorName;
  final String specialty;

  const MedicineCard({
    required this.medicineName,
    required this.doctorName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(
                          'assets/doctor.png'), // Add your doctor image
                    ),
                    SizedBox(width: 8),
                    Text("$doctorName  |  $specialty",
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text("Buy", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Report Card Widget
class ReportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Report",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date", style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("28 February 2025",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patient", style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("Najam Ul Fazal",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Disease", style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("Pneumonia",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Next Appointment",
                        style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text("5 March 2025",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Medicine Table
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Medicine",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Doze",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Time",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                medicineRow("Panadol 50mg", "2x", "8am"),
                medicineRow("Panadol 50mg", "2x", "1pm"),
                medicineRow("Arinac Forte 10mg", "1x", "8am"),
                medicineRow("Arinac Forte 10mg", "1x", "8pm"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate table row
  TableRow medicineRow(String name, String dose, String time) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dose),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(time),
        ),
      ],
    );
  }
}
