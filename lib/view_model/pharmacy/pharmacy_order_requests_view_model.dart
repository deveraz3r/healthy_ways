import 'package:get/get.dart';

class OrderRequest {
  final String time;
  final String date;
  final String patientName;
  final String patientImage;
  final List<Medicine> medicines;
  bool isApproved; // Track if order is approved

  OrderRequest({
    required this.time,
    required this.date,
    required this.patientName,
    required this.patientImage,
    required this.medicines,
    this.isApproved = false,
  });
}

class Medicine {
  final String name;
  final String quantity;
  final String dosage;

  Medicine({
    required this.name,
    required this.quantity,
    required this.dosage,
  });
}

class PharmacyOrderRequestsViewModel extends GetxController {
  var orders = <OrderRequest>[
    OrderRequest(
      time: "10pm",
      date: "March 10th, 2025",
      patientName: "Peter Parker",
      patientImage: "assets/profile.png",
      medicines: [
        Medicine(name: "Panadol Extra", quantity: "2 packs", dosage: "100mg"),
        Medicine(name: "Paracetamol", quantity: "1 pack", dosage: "50mg"),
      ],
    ),
    OrderRequest(
      time: "10pm",
      date: "March 9th, 2025",
      patientName: "Peter Parker",
      patientImage: "assets/profile.png",
      medicines: [
        Medicine(name: "Panadol Extra", quantity: "2 packs", dosage: "100mg"),
        Medicine(name: "Paracetamol", quantity: "1 pack", dosage: "50mg"),
      ],
    ),
  ].obs;

  void approveOrder(int index) {
    orders[index].isApproved = true;
    update();
  }

  void rejectOrder(int index) {
    orders[index].isApproved = false;
    update();
  }
}
