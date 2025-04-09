import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';

class PharmacistOrderDetailsView extends StatefulWidget {
  const PharmacistOrderDetailsView({super.key});

  @override
  State<PharmacistOrderDetailsView> createState() =>
      _PharmacistOrderDetailsViewState();
}

class _PharmacistOrderDetailsViewState
    extends State<PharmacistOrderDetailsView> {
  final OrderModel order = Get.arguments as OrderModel;
  final Rx<PatientModel?> patient = Rx<PatientModel?>(null);
  final Rx<PharmacistModel?> pharmacist = Rx<PharmacistModel?>(null);
  final OrderViewModel orderVM = Get.find<OrderViewModel>();

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  void loadProfiles() async {
    patient.value = await Get.find<ProfileViewModel>()
        .getProfileDataById<PatientModel>(order.patientId);

    if (order.pharmacistId != null) {
      pharmacist.value = await Get.find<ProfileViewModel>()
          .getProfileDataById<PharmacistModel>(order.pharmacistId!);
    }
  }

  void _showAddUpdateDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Send Order Update"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter update message"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final message = controller.text.trim();
              if (message.isNotEmpty) {
                await orderVM.sendOrderUpdate(order.id, message);
                Get.back();
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.inProgress:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicines = order.medicines.map((m) {
      final medicineName =
          Get.find<MedicineViewModel>().getMedicineNameById(m['id']);
      return {'name': medicineName, 'quantity': m['quantity']};
    }).toList();

    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Order (${order.id})",
        enableBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _showAddUpdateDialog,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Order Status"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: _getStatusColor(order.status)),
                  const SizedBox(width: 8),
                  Text(
                    OrderModel.orderStatusToString(order.status).toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => patient.value != null
                ? _profileCard(
                    title: "Patient",
                    name: patient.value!.fullName,
                    email: patient.value!.email,
                    imageUrl: patient.value!.profileImage,
                  )
                : const CircularProgressIndicator()),
            const SizedBox(height: 16),
            _sectionTitle("Delivery Info"),
            _infoRow("Delivery Address", order.address ?? "N/A"),
            _infoRow("Order Time",
                DateFormat.yMd().add_jm().format(order.orderTime)),
            const SizedBox(height: 16),
            _sectionTitle("Medicines"),
            ...medicines.map((m) => ListTile(
                  title: Text(m['name']),
                  trailing: Text("Qty: ${m['quantity']}"),
                )),
            const SizedBox(height: 16),
            _sectionTitle("Order Updates"),
            ...order.updates.map((u) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.update, color: Colors.blueAccent),
                    title: Text(u.message),
                    subtitle:
                        Text(DateFormat.yMd().add_jm().format(u.timestamp)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _profileCard({
    required String title,
    required String name,
    required String email,
    required String? imageUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              radius: 30,
              child: imageUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(email, style: const TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
