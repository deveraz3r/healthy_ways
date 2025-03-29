import 'dart:math';

import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';

class InventoryAddItemView extends StatelessWidget {
  final InventoryViewModel inventoryViewModel = Get.find();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _formulaController = TextEditingController();
  final _quantityController = TextEditingController();
  final _quantityTypeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: ('Add New Medicine'),
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Medicine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medicine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _formulaController,
                decoration: InputDecoration(labelText: 'Formula'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the formula';
                  }
                  return null;
                },
              ),
              TextFormField(
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
              TextFormField(
                controller: _quantityTypeController,
                decoration: InputDecoration(labelText: 'Quantity Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL (optional)'),
              ),
              // SwitchListTile(
              //   title: Text('In Stock'),
              //   value: _isInStock,
              //   onChanged: (value) {
              //     _isInStock = value;
              //   },
              // ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Create a new Medicine object
                        final newMedicine = MedicineModel(
                          id: Random()
                              .nextInt(99999999), //TODO: change to dynamic id
                          name: _nameController.text,
                          formula: _formulaController.text,
                          stock: int.parse(_quantityController.text),
                          stockType: _quantityTypeController.text,
                          imageUrl: _imageUrlController.text.isEmpty
                              ? null
                              : _imageUrlController.text,
                        );

                        // Add the new medicine to the inventory
                        inventoryViewModel.inventory.add(newMedicine);

                        // Navigate back to the inventory page
                        Get.back();
                      }
                    },
                    child: Center(
                        child: Text(
                      "Add Medicine",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
