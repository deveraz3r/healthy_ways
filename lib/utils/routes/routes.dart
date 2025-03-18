import 'package:healty_ways/view/patient/appointment_history_view.dart';
import 'package:healty_ways/view/patient/appointment_report_view.dart';
import 'package:healty_ways/view/patient/book_doctor_details_view.dart';
import 'package:healty_ways/view/patient/book_doctor_view.dart';
import 'package:healty_ways/view/patient/checkout_view.dart';
import 'package:healty_ways/view/patient/home_view.dart';
import 'package:healty_ways/view/patient/inventory_add_item_view.dart';
import 'package:healty_ways/view/patient/inventory_view.dart';
import 'package:healty_ways/view/patient/medication_history_view.dart';
import 'package:healty_ways/view/patient/pharmacy_delivery_view.dart';
import 'package:healty_ways/view/patient/request_medicne_view.dart';
import 'package:healty_ways/view/shared/auth/login_view.dart';
import 'package:healty_ways/view/shared/auth/signup_view.dart';
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
        GetPage(
          name: RouteName.patientRequestMedicineCheckout,
          page: () => CheckoutView(),
        ),
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
          page: () => AppointmentHistoryView(),
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

        //------------------- Doctor -------------------

        //------------------- Pharmacy -------------------
      ];
}
