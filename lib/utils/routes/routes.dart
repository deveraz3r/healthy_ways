import 'package:healty_ways/view/doctor/doctor_allergy_view.dart';
import 'package:healty_ways/view/doctor/doctor_appointment_history_details_view.dart';
import 'package:healty_ways/view/doctor/doctor_appointment_start_view.dart';
import 'package:healty_ways/view/doctor/doctor_appointments_view.dart';
import 'package:healty_ways/view/doctor/doctor_assigned_patients_view.dart';
import 'package:healty_ways/view/doctor/doctor_home_view.dart';
import 'package:healty_ways/view/doctor/doctor_immunization_view.dart';
import 'package:healty_ways/view/doctor/doctor_medicine_assign_view.dart';
import 'package:healty_ways/view/doctor/doctor_profile_view.dart';
import 'package:healty_ways/view/patient/patient_allergy_view.dart';
import 'package:healty_ways/view/patient/patient_appointment_history_view.dart';
import 'package:healty_ways/view/patient/appointment_report_view.dart';
import 'package:healty_ways/view/patient/book_doctor_details_view.dart';
import 'package:healty_ways/view/patient/book_doctor_view.dart';
import 'package:healty_ways/view/patient/home_view.dart';
import 'package:healty_ways/view/patient/inventory_add_item_view.dart';
import 'package:healty_ways/view/patient/inventory_view.dart';
import 'package:healty_ways/view/patient/medication_history_view.dart';
import 'package:healty_ways/view/patient/patient_appointment_start_view.dart';
import 'package:healty_ways/view/patient/patient_book_appointment.dart';
import 'package:healty_ways/view/patient/patient_diary_enteries_view.dart';
import 'package:healty_ways/view/patient/patient_immunization_view.dart';
import 'package:healty_ways/view/patient/patient_profile_view.dart';
import 'package:healty_ways/view/patient/pharmacy_delivery_view.dart';
import 'package:healty_ways/view/patient/request_medicne_view.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_home_view.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_inventory_view.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_lab_records.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_orders_request_view.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_delivery_status_view.dart';
import 'package:healty_ways/view/pharmacy/pharmacy_upload_lab_report_view.dart';
import 'package:healty_ways/view/shared/all_medicine_view.dart';
import 'package:healty_ways/view/shared/auth/login_view.dart';
import 'package:healty_ways/view/shared/auth/signup_view.dart';
import 'package:healty_ways/view/shared/chat_view.dart';
import 'package:healty_ways/view/shared/diary_entery_view.dart';
import 'package:healty_ways/view/shared/splash_view.dart';

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
          name: RouteName.chatView,
          page: () => ChatView(),
        ),
        GetPage(
          name: RouteName.diaryEnteryView,
          page: () => DiaryEnteryView(),
        ),
        GetPage(
          name: RouteName.allMedicinesView,
          page: () => AllMedicineView(),
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
          name: RouteName.patientPharmacy,
          page: () => PharmacyView(),
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
      ];
}
