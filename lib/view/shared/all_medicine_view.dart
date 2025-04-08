import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';

class AllMedicineView extends StatelessWidget {
  final MedicineViewModel viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "All Medicines",
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show a dialog to add new medicine
              _showAddMedicineDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (viewModel.allMedicines.isEmpty) {
          return Center(child: Text("No medicines available"));
        }

        return RefreshIndicator(
          onRefresh: _refreshMedicines, // Trigger the refresh when pulled down
          child: ListView.builder(
            itemCount: viewModel.allMedicines.length,
            itemBuilder: (context, index) {
              final medicine = viewModel.allMedicines[index];
              return ListTile(
                title: Text(medicine.name),
                subtitle: Text(medicine.formula),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Show edit dialog with the selected medicine
                        _showEditMedicineDialog(context, medicine);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        viewModel.deleteMedicine(medicine);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Show dialog for adding a new medicine
  void _showAddMedicineDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController formulaController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController stockTypeController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Medicine'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: formulaController,
                  decoration: InputDecoration(labelText: 'Formula'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: stockTypeController,
                  decoration: InputDecoration(labelText: 'Stock Type'),
                ),
                // TextField(
                //   controller: stockController,
                //   decoration: InputDecoration(labelText: 'Stock Quantity'),
                //   keyboardType: TextInputType.number,
                // ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final medicine = MedicineModel(
                  id: "", // Firestore will generate an ID
                  name: nameController.text,
                  formula: formulaController.text,
                  description: descriptionController.text,
                  stockType: stockTypeController.text,
                  // stock: int.tryParse(stockController.text) ?? 0,
                  imageUrl: imageUrlController.text,
                );
                // Add medicine to Firestore and list
                viewModel.addMedicine(medicine);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for editing a medicine
  void _showEditMedicineDialog(BuildContext context, MedicineModel medicine) {
    final TextEditingController nameController =
        TextEditingController(text: medicine.name);
    final TextEditingController formulaController =
        TextEditingController(text: medicine.formula);
    // final TextEditingController stockController = TextEditingController(text: medicine.stock.toString());
    final TextEditingController descriptionController =
        TextEditingController(text: medicine.description ?? "");
    final TextEditingController stockTypeController =
        TextEditingController(text: medicine.stockType);
    final TextEditingController imageUrlController =
        TextEditingController(text: medicine.imageUrl ?? "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Medicine'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: formulaController,
                  decoration: InputDecoration(labelText: 'Formula'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: stockTypeController,
                  decoration: InputDecoration(labelText: 'Stock Type'),
                ),
                // TextField(
                //   controller: stockController,
                //   decoration: InputDecoration(labelText: 'Stock Quantity'),
                //   keyboardType: TextInputType.number,
                // ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedMedicine = medicine.copyWith(
                  name: nameController.text,
                  formula: formulaController.text,
                  description: descriptionController.text,
                  stockType: stockTypeController.text,
                  // stock: int.tryParse(stockController.text) ?? 0,
                  imageUrl: imageUrlController.text,
                );
                viewModel.updateMedicine(updatedMedicine);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Refresh the medicines list
  Future<void> _refreshMedicines() async {
    await viewModel.fetchAllMedicines();
  }
}
