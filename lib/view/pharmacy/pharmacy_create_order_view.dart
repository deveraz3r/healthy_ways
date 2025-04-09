import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/view_model/patients_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class OrderFormView extends StatefulWidget {
  const OrderFormView({super.key});

  @override
  State<OrderFormView> createState() => _OrderFormViewState();
}

class _OrderFormViewState extends State<OrderFormView> {
  final orderViewModel = Get.find<OrderViewModel>();
  final medicineViewModel = Get.find<MedicineViewModel>();
  final patientsViewModel = Get.find<PatientsViewModel>();

  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    medicineViewModel.fetchAllMedicinesBySearch('');
    patientsViewModel.fetchAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ('Order Form'),
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPatientField(),
            const SizedBox(height: 20),
            _buildSelectMedicineField(),
            const SizedBox(height: 20),
            _buildAddressField(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientField() {
    return GestureDetector(
      onTap: () async {
        final selected = await _showPatientSelectionDialog(context);
        if (selected != null) {
          setState(() {
            orderViewModel.order.update((order) {
              order?.patientId = selected.uid;
            });
          });
        } else {
          Get.snackbar("Failed!", "Failed to load patient");
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            // labelText: 'Patient',
            hintText: orderViewModel.order.value.patientId?.isNotEmpty == true
                ? _getPatientName(orderViewModel
                    .order.value.patientId!) // Fetch patient's name
                : 'Select a patient',
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }

  //TODO: use VM function to get patient
  String _getPatientName(String patientId) {
    final patient = patientsViewModel.patients.firstWhere(
      (patient) => patient.uid == patientId,
      orElse: () => PatientModel(
        uid: "Unknown",
        email: "unknown@unknown.com",
        fullName: 'Unknown',
      ),
    );
    return patient.fullName;
  }

  Widget _buildSelectMedicineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Selected Medicines"),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: orderViewModel.order.value.medicines
              .map((medicine) => Chip(
                    label: Text(
                      "${medicine['name']} (Qty: ${medicine['quantity']})",
                    ),
                    onDeleted: () {
                      setState(() {
                        orderViewModel.order.update((order) {
                          order?.medicines.remove(medicine);
                        });
                      });
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        ReuseableElevatedbutton(
          buttonName: "Add Medicine",
          onPressed: () async {
            final selected = await _showMedicineSelectionDialog(context);
            if (selected != null) {
              // Ask for quantity
              final quantityController = TextEditingController();
              final quantity =
                  await _showQuantityDialog(context, quantityController);

              if (quantity != null && quantity > 0) {
                setState(() {
                  orderViewModel.order.update((order) {
                    if (!(order?.medicines
                            ?.any((item) => item['id'] == selected.id) ??
                        false)) {
                      order?.medicines?.add({
                        'id': selected.id,
                        'name': selected.name, // Save the medicine name
                        'quantity': quantity,
                      });
                    }
                  });
                });
              } else {
                // Show Snackbar if no quantity or invalid quantity
                Get.snackbar(
                  "Invalid Quantity",
                  "Please enter a valid quantity greater than 0.",
                  backgroundColor: Colors.red.shade100,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }
          },
        )
      ],
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: addressController,
      decoration: const InputDecoration(
        labelText: 'Order Address',
        hintText: 'Enter delivery address',
      ),
      onChanged: (value) {
        orderViewModel.order.update((order) {
          order?.address = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ReuseableElevatedbutton(
        onPressed: () async {
          final profileVM = Get.find<ProfileViewModel>();
          final pharmacistId = profileVM.profile?.uid;
          orderViewModel.order.update((order) {
            order?.pharmacistId = pharmacistId;
          });

          final isValid = await _validateAndAdjustInventory();
          if (!isValid) return;

          await orderViewModel.createOrder(orderViewModel.order.value);

          orderViewModel.resetOrder();
          Get.back();
        },
        buttonName: ('Submit Order'),
      ),
    );
  }

  Future<bool> _validateAndAdjustInventory() async {
    final inventoryVM = Get.find<InventoryViewModel>();
    await inventoryVM.fetchInventory();

    final inventory = inventoryVM.inventory;
    final orderItems = orderViewModel.order.value.medicines;

    bool hasError = false;
    String errorMessage = "";

    for (var item in orderItems) {
      final String medicineId = item['id'].toString();
      final int requestedQty = item['quantity'];

      final invItem = inventory
          .firstWhereOrNull((inv) => inv.medicineId.toString() == medicineId);

      if (invItem == null || invItem.stock < requestedQty) {
        hasError = true;
        errorMessage +=
            "- ${item['name']} (requested: $requestedQty, available: ${invItem?.stock ?? 0})\n";
      }
    }

    if (hasError) {
      Get.snackbar("Not Enough Stock", errorMessage.trim(),
          backgroundColor: Colors.red.shade100,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // If valid, subtract stock
    for (var item in orderItems) {
      final String medicineId = item['id'].toString();
      final int requestedQty = item['quantity'];

      final index = inventory
          .indexWhere((inv) => inv.medicineId.toString() == medicineId);
      if (index != -1) {
        inventory[index].stock -= requestedQty;

        // ✅ Use the updated value
        await inventoryVM.updateStock(
          medicineId,
          inventory[index].stock,
        );
      }
    }

    return true;
  }

  Future<MedicineModel?> _showMedicineSelectionDialog(
      BuildContext context) async {
    final searchController = TextEditingController();
    medicineViewModel.fetchAllMedicinesBySearch('');

    return await showDialog<MedicineModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Medicine'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search medicine',
                ),
                onChanged: (value) {
                  medicineViewModel.fetchAllMedicinesBySearch(value);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: medicineViewModel.allMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicineViewModel.allMedicines[index];
                      return ListTile(
                        title: Text(medicine.name), // Display the name
                        subtitle: Text(medicine.formula),
                        onTap: () {
                          Navigator.of(context).pop(medicine);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int?> _showQuantityDialog(
      BuildContext context, TextEditingController controller) async {
    return await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Quantity'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(controller.text));
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<PatientModel?> _showPatientSelectionDialog(
      BuildContext context) async {
    return await showDialog<PatientModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Patient'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Obx(() {
              return ListView.builder(
                itemCount: patientsViewModel.patients.length,
                itemBuilder: (context, index) {
                  final patient = patientsViewModel.patients[index];
                  return ListTile(
                    title: Text(patient.fullName),
                    onTap: () {
                      Navigator.of(context).pop(patient);
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
