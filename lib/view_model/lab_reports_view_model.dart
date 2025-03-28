import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/lab_report_model.dart';
import 'package:get/get.dart';

class LabReportsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<LabReportModel> _reports = <LabReportModel>[].obs;

  List<LabReportModel> get reports => _reports;

  Future<void> fetchPatientReports(String patientId) async {
    final query = await _firestore
        .collection('lab_reports')
        .where('patientId', isEqualTo: patientId)
        .orderBy('date', descending: true)
        .get();

    _reports.assignAll(
        query.docs.map((doc) => LabReportModel.fromJson(doc.data())).toList());
  }

  Future<void> updateReportStatus(
      String reportId, LabReportStatus newStatus) async {
    // Convert enum to string for Firestore
    final statusStr = newStatus.toString().split('.').last;

    await _firestore.collection('lab_reports').doc(reportId).update({
      'status': statusStr,
      'updates': FieldValue.arrayUnion([
        {
          'timestamp': DateTime.now().toIso8601String(),
          'message': 'Status changed to $statusStr'
        }
      ])
    });

    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: newStatus);
      _reports.refresh();
    }
  }

  // Helper method to get string representation of status
  String getStatusString(LabReportStatus status) {
    return status.toString().split('.').last;
  }
}
