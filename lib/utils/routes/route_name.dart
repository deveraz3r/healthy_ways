class RouteName {
  //------------------- Shared -------------------
  static const String splash = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String chatView = "/chatView";

  //------------------- Patient -------------------
  static const String patientHome = "/patientHome";
  static const String patientInventory = "/patientInventory";
  static const String patientInventoryAddItem = "/patientInventoryAddItem";
  static const String patientPharmacy = "/patientPharmacy";
  static const String patientDliveryStatus = "/patientDliveryStatus";
  static const String patientRequestMedication = "/patientRequestMedication";
  static const String patientRequestMedicineCheckout =
      "/patientRequestMedicineCheckout";
  static const String patientMedicationsHistory = "/patientMedicationsHistory";
  static const String patientAppointmentHistory = "/patientAppointmentHistory";
  static const String patientAppointmentReport = "/patientAppointmentReport";
  static const String patientBookDoctor = "/patientBookDoctor";
  static const String patientBookDoctorDetails = "/patientBookDoctorDetails";

  //------------------- Doctor -------------------
  static const String doctorHomeView = "/doctorHomeView";
  static const String doctorAppointmentsView = "/doctorAppointmentsView";
  static const String doctorAppointmentHistoryDetailsView =
      "/doctorAppointmentHistoryDetailsView";
  static const String doctorAssignedPatientsView =
      "/doctorAssignedPatientsView";
  static const String doctorAssignedPatientDetailsView =
      "/doctorAssignedPatientDetailsView";
  static const String doctorProfileView = "/doctorProfileView";

  //------------------- Pharmacy -------------------
  static const String pharmacyHomeView = "/pharmacyHomeView";
  static const String pharmacyInventoryView = "/pharmacyInventoryView";
  static const String pharmacyLabRecords = "/pharmacyLabRecords";
  static const String pharmacyOrdersRequestView = "/pharmacyOrdersRequestView";
  static const String pharmacyDeliveryStatusView =
      "/pharmacyDeliveryStatusView";
  static const String pharmacyUploadLabReportView =
      "/pharmacyUploadLabReportView";
}
