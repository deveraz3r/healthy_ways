import 'package:healty_ways/utils/app_urls.dart';

class LabReportsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  final RxList<LabReportModel> _reports = <LabReportModel>[].obs;
  List<LabReportModel> get reports => _reports;

  @override
  onInit() {
    super.onInit();
    fetchUserReports(
      _profileVM.profile!.uid,
      _profileVM.profile!.role,
    );
  }

  // Fetch lab reports for the current user (patient or pharmacist)
  Future<void> fetchUserReports(String userId, UserRole role) async {
    try {
      final String field;

      switch (role) {
        case UserRole.patient:
          field = 'patientId';
          break;
        case UserRole.pharmacist:
          field = 'pharmacistId';
          break;
        case UserRole.doctor:
          throw Exception("doctor lab report fetching not implemented yet.");
        // field = 'doctorId'; //only for future use
        // break;
        default:
          throw Exception("Invalid user role for fetching lab reports.");
      }

      final query = await _firestore
          .collection('lab_reports')
          .where(field, isEqualTo: userId)
          // .orderBy('date', descending: true)
          .get();

      _reports.assignAll(query.docs
          .map((doc) => LabReportModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      _handleError("Failed to fetch lab reports", e);
    }
  }

  // Create a new lab report (Pending State)
  Future<void> createLabReport(LabReportModel newLabReport) async {
    try {
      final docRef = _firestore.collection('lab_reports').doc();

      newLabReport = newLabReport.copyWith(
        id: docRef.id, //unique id
        date: DateTime.now(),
        status: LabReportStatus.pending, //default status
      );

      await docRef.set(newLabReport.toJson());
      _reports.add(newLabReport);

      Get.snackbar("Success", "Lab report created successfully.");
    } catch (e) {
      _handleError("Failed to create lab report", e);
    }
  }

  // Update the status of a lab report
  Future<void> updateLabReportStatus({
    required String reportId,
    required LabReportStatus newStatus,
  }) async {
    try {
      await _firestore.collection('lab_reports').doc(reportId).update({
        'status': newStatus.name,
      });

      // update locally
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _reports[index] = _reports[index].copyWith(status: newStatus);
        _reports.refresh();
      }

      Get.snackbar(
          "Success", "Lab report status updated to ${newStatus.name}.");
    } catch (e) {
      _handleError("Failed to update lab report status", e);
    }
  }

  // Upload files to a lab report
  Future<void> uploadLabReportFiles({
    required String reportId,
    required List<String> fileUrls,
  }) async {
    try {
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index == -1) {
        throw Exception("Lab report not found.");
      }

      final updatedFiles = [...?_reports[index].attachedFiles, ...fileUrls];

      await _firestore.collection('lab_reports').doc(reportId).update({
        'attachedFiles': updatedFiles,
      });

      _reports[index] = _reports[index].copyWith(attachedFiles: updatedFiles);
      _reports.refresh();

      Get.snackbar("Success", "Files uploaded successfully.");
    } catch (e) {
      _handleError("Failed to upload files to lab report", e);
    }
  }

  // Delete a lab report
  Future<void> deleteLabReport(String reportId) async {
    try {
      await _firestore.collection('lab_reports').doc(reportId).delete();

      _reports.removeWhere((r) => r.id == reportId); // Remove from local list
      _reports.refresh();

      Get.snackbar("Success", "Lab report deleted successfully.");
    } catch (e) {
      _handleError("Failed to delete lab report", e);
    }
  }

  // Group lab reports by date
  Map<DateTime, List<LabReportModel>> getReportsGroupedByDate() {
    final groupedReports = <DateTime, List<LabReportModel>>{};

    for (final report in _reports) {
      final date = report.date.dateOnly;

      groupedReports.putIfAbsent(date, () => []);
      groupedReports[date]!.add(report);
    }

    return groupedReports;
  }

  // Error handling
  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}

extension on DateTime {
  get dateOnly => DateTime(year, month, day);
  get timeOnly => DateTime(year, month, day, hour, minute, second);
}
