import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';

class PharmacyInventoryAddItemView extends StatefulWidget {
  @override
  _PharmacyInventoryAddItemViewState createState() =>
      _PharmacyInventoryAddItemViewState();
}

class _PharmacyInventoryAddItemViewState
    extends State<PharmacyInventoryAddItemView> {
  final InventoryViewModel inventoryViewModel = Get.find();
  final MedicineViewModel medicineViewModel = Get.find();

  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();

  String? selectedMedicineId;
  MedicineModel? selectedMedicine;

  RxList<MedicineModel> filteredMedicines = RxList<MedicineModel>();

  @override
  void initState() {
    super.initState();
    filteredMedicines.assignAll(medicineViewModel.allMedicines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Add Medicine to Pharmacy Inventory',
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Medicine',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterMedicines,
            ),
            SizedBox(height: 16),

            // Filtered List
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: filteredMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = filteredMedicines[index];
                    return ListTile(
                      title: Text(medicine.name),
                      subtitle: Text(medicine.formula),
                      onTap: () {
                        _quantityController.clear();
                        setState(() {
                          selectedMedicine = medicine;
                          selectedMedicineId = medicine.id;
                        });
                      },
                    );
                  },
                ),
              );
            }),

            // Input + Action
            if (selectedMedicine != null) ...[
              SizedBox(height: 16),
              Text("Selected: ${selectedMedicine!.name}"),
              Text("Formula: ${selectedMedicine!.formula}"),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: ReuseableElevatedbutton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedMedicine != null) {
                      final quantity = int.parse(_quantityController.text);

                      inventoryViewModel.addMedicineToInventory(
                        selectedMedicineId!,
                        quantity,
                      );

                      Get.back(); // back to inventory
                    }
                  },
                  buttonName: "Add to Inventory",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _filterMedicines(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMedicines.assignAll(medicineViewModel.allMedicines);
      });
    } else {
      setState(() {
        filteredMedicines.assignAll(
          medicineViewModel.allMedicines
              .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
              .toList(),
        );
      });
    }
  }
}
