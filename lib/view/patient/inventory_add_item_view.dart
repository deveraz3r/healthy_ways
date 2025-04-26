import 'package:healty_ways/utils/app_urls.dart';

class InventoryAddItemView extends StatefulWidget {
  @override
  _InventoryAddItemViewState createState() => _InventoryAddItemViewState();
}

class _InventoryAddItemViewState extends State<InventoryAddItemView> {
  final InventoryViewModel inventoryViewModel = Get.find();
  final MedicineViewModel medicineViewModel = Get.find();

  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();

  MedicineModel? selectedMedicine;

  // Filtered list of medicines based on search input
  RxList<MedicineModel> filteredMedicines = RxList<MedicineModel>();

  @override
  void initState() {
    super.initState();
    // Set the initial filtered list to all medicines when the page loads
    filteredMedicines.assignAll(medicineViewModel.allMedicines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ('Add Medicine to Inventory'),
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Medicine',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                // Filter medicines based on the search input
                _filterMedicines(query);
              },
            ),
            const SizedBox(height: 16),

            // Searchable List of Available Medicines
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
                        // Reset the quantity controller whenever a new medicine is selected
                        _quantityController.clear();

                        // Update the selected medicine details
                        setState(() {
                          selectedMedicine = medicine;
                        });
                      },
                    );
                  },
                ),
              );
            }),

            // Display medicine details and the quantity input field
            if (selectedMedicine != null) ...[
              const SizedBox(height: 16),
              Text("Selected Medicine: ${selectedMedicine!.name}"),
              Text("Formula: ${selectedMedicine!.formula}"),

              // Quantity input field
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Add to inventory button
              Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selectedMedicine != null ? Colors.blue : Colors.grey,
                ),
                child: ReuseableElevatedbutton(
                  onPressed: selectedMedicine == null
                      ? null
                      : () {
                          if (_formKey.currentState!.validate() &&
                              selectedMedicine != null) {
                            final quantity =
                                int.parse(_quantityController.text);

                            inventoryViewModel.addMedicineToInventory(
                              InventoryModel(
                                medicineId: selectedMedicine!.id,
                                stock: quantity,
                                userId: inventoryViewModel.userId.value,
                              ),
                            );

                            Get.back(); // Navigate back to inventory
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

  // Method to filter medicines based on search query
  void _filterMedicines(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all medicines
      setState(() {
        filteredMedicines.assignAll(medicineViewModel.allMedicines);
      });
    } else {
      // Filter medicines by name
      setState(() {
        filteredMedicines.assignAll(medicineViewModel.allMedicines
            .where((medicine) =>
                medicine.name.toLowerCase().contains(query.toLowerCase()))
            .toList());
      });
    }
  }
}
