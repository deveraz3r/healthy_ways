import 'package:healty_ways/view/patient/home_view.dart';

import '/utils/app_urls.dart';

class Routes {
  //GetX
  static appRoutes() => [
        //------------------- Shared -------------------

        //------------------- Patient -------------------
        GetPage(name: RouteName.patientHome, page: () => HomeView()),
        GetPage(name: RouteName.patientInventory, page: () => HomeView()),
        GetPage(name: RouteName.patientDliveryStatus, page: () => HomeView()),
        GetPage(
            name: RouteName.patientRequestMedication, page: () => HomeView()),
        GetPage(
            name: RouteName.patientMedicationsHistory, page: () => HomeView()),
        GetPage(
            name: RouteName.patientAppointmentHistory, page: () => HomeView()),
        GetPage(
            name: RouteName.patientAppointmentHistoryDetails,
            page: () => HomeView()),
        GetPage(name: RouteName.patientBookDoctor, page: () => HomeView()),
        GetPage(
            name: RouteName.patientBookDoctorDetails, page: () => HomeView()),

        //------------------- Doctor -------------------

        //------------------- Pharmacy -------------------
      ];
}
