import 'package:healty_ways/view/shared/lab_report_details_view.dart';
import 'package:healty_ways/view/shared/lab_reports_list.dart';

import '/utils/app_urls.dart';

class Routes {
  //GetX
  static appRoutes() => [
        //------------------- Shared -------------------
        GetPage(
          name: RouteName.patientHome,
          page: () => HomeView(),
        ),
        GetPage(
          name: RouteName.splash,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: RouteName.signup,
          page: () => SignupView(),
        ),
        GetPage(
          name: RouteName.login,
          page: () => LoginView(),
        ),
        GetPage(
          name: RouteName.oneToOneChatsListView,
          page: () => OneToOneChatsListView(),
        ),
        GetPage(
          name: RouteName.chatView,
          page: () => ChatView(),
        ),
        GetPage(
          name: RouteName.chatComponent,
          page: () => AppointmentChatView(),
        ),
        GetPage(
          name: RouteName.diaryEnteryView,
          page: () => DiaryEnteryView(),
        ),
        GetPage(
          name: RouteName.allMedicinesView,
          page: () => AllMedicineView(),
        ),
        GetPage(
          name: RouteName.labReportDetailsView,
          page: () => LabReportDetailsView(),
        ),
        GetPage(
          name: RouteName.labReportsListView,
          page: () => LabReportsListView(),
        ),

        //------------------- Patient -------------------
        GetPage(
          name: RouteName.patientInventory,
          page: () => InventoryView(),
        ),
        GetPage(
          name: RouteName.patientInventoryAddItem,
          page: () => InventoryAddItemView(),
        ),
        GetPage(
          name: RouteName.patientOrdersView,
          page: () => PatientOrdersView(),
        ),
        GetPage(
          name: RouteName.patientOrdersDetailsView,
          page: () => PatientOrdersDetailsView(),
        ),
        // GetPage(
        //   name: RouteName.patientRequestMedicineCheckout, //add args while calling
        //   page: () => CheckoutView(),
        // ),
        // GetPage(
        //   name: RouteName.patientDliveryStatus,
        //   page: () => HomeView(),
        // ),
        GetPage(
          name: RouteName.patientRequestMedication,
          page: () => RequestMedicneView(),
        ),
        GetPage(
          name: RouteName.patientContactPharmacistView,
          page: () => PatientContactPharmacistView(),
        ),
        GetPage(
          name: RouteName.patientMedicationsHistory,
          page: () => MedicationHistoryView(),
        ),
        GetPage(
          name: RouteName.patientAppointmentHistory,
          page: () => PatientAppointmentHistoryView(),
        ),
        GetPage(
          name: RouteName.patientAppointmentReport,
          page: () => AppointmentReportView(),
        ),
        GetPage(
          name: RouteName.patientBookDoctor,
          page: () => BookDoctorView(),
        ),
        GetPage(
          name: RouteName.patientBookDoctorDetails,
          page: () => BookDoctorDetailsView(),
        ),
        GetPage(
          name: RouteName.patientProfileView,
          page: () => PatientProfileView(),
        ),
        GetPage(
          name: RouteName.patientAppointmentStartView,
          page: () => PatientAppointmentStartView(),
        ),
        GetPage(
          name: RouteName.patientAllergyView,
          page: () => PatientAllergyView(),
        ),
        GetPage(
          name: RouteName.patientImmunizationView,
          page: () => PatientImmunizationView(),
        ),
        GetPage(
          name: RouteName.patientDiaryEnteriesView,
          page: () => PatientDiaryEnteriesView(),
        ),
        // GetPage(
        //   name: RouteName.patientBookAppointmentView,
        //   page: () => PatientBookAppointmentView(doctor: doctor model,),
        // ),

        //------------------- Doctor -------------------

        GetPage(
          name: RouteName.doctorHomeView,
          page: () => DoctorHomeView(),
        ),
        GetPage(
          name: RouteName.doctorAppointmentsView,
          page: () => DoctorAppointmentsView(),
        ),
        GetPage(
          name: RouteName.doctorAppointmentHistoryDetailsView,
          page: () => DoctorAppointmentHistoryDetailsView(),
        ),
        GetPage(
          name: RouteName.doctorAssignedPatientsView,
          page: () => DoctorAssignedPatientsView(),
        ),
        // GetPage(
        //   name: RouteName.doctorAssignedPatientDetailsView,
        //   page: () => DoctorAssignedPatientDetailsView(),  //add args while calling
        // ),
        GetPage(
          name: RouteName.doctorProfileView,
          page: () => DoctorProfileView(),
        ),
        GetPage(
          name: RouteName.doctorAppointmentStartView,
          page: () => DoctorAppointmentStartView(),
        ),
        GetPage(
          name: RouteName.doctorAllergyView,
          page: () => DoctorAllergyView(),
        ),
        GetPage(
          name: RouteName.doctorImmunizationView,
          page: () => DoctorImmunizationView(),
        ),
        GetPage(
          name: RouteName.doctorMedicineAssignView,
          page: () => DoctorMedicineAssignView(),
        ),

        //------------------- Pharmacy -------------------
        GetPage(
          name: RouteName.pharmacyHomeView,
          page: () => PharmacyHomeView(),
        ),
        GetPage(
          name: RouteName.pharmacyInventoryView,
          page: () => PharmacyInventoryView(),
        ),
        GetPage(
          name: RouteName.pharmacyLabRecords,
          page: () => PharmacyLabRecords(),
        ),
        GetPage(
          name: RouteName.pharmacyOrdersRequestView,
          page: () => PharmacyOrdersRequestView(),
        ),
        GetPage(
          name: RouteName.pharmacyDeliveryStatusView,
          page: () => PharmacyDeliveryStatusView(),
        ),
        GetPage(
          name: RouteName.pharmacyUploadLabReportView,
          page: () => PharmacyUploadLabReportView(),
        ),
        GetPage(
          name: RouteName.pharmacistCreateOrderView,
          page: () => OrderFormView(),
        ),
        GetPage(
          name: RouteName.pharmacyInventoryAddItem,
          page: () => PharmacyInventoryAddItemView(),
        ),
        GetPage(
          name: RouteName.pharmacistProfileView,
          page: () => PharmacistProfileView(),
        ),
        GetPage(
          name: RouteName.pharmacistOrderDetailsView,
          page: () => PharmacistOrderDetailsView(),
        ),
      ];
}
