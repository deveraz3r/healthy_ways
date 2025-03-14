import 'package:flutter/material.dart';
import 'package:healty_ways/resources/components/inventory_medicne_card.dart';
import 'package:healty_ways/resources/components/reusable_app_bar.dart';
import 'package:healty_ways/utils/app_urls.dart';

class InventoryView extends StatelessWidget {
  InventoryView({super.key});

  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Panadol Extra',
      'quantity': '2 Packs',
      'dosage': '100mg',
      'inStock': true
    },
    {
      'name': 'Paracetamol',
      'quantity': '5 Packs',
      'dosage': '500mg',
      'inStock': false
    },
    {
      'name': 'Ibuprofen',
      'quantity': '1 Pack',
      'dosage': '200mg',
      'inStock': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Inventory",
        enableBack: true,
        actions: [
          InkWell(
            onTap: () {
              //TODO: request medicne page
              Get.toNamed(RouteName.patientRequestMedication);
            },
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return InventoryMedicneCard(
            name: medicines[index]['name'],
            quantity: medicines[index]['quantity'],
            dosage: medicines[index]['dosage'],
            isInStock: medicines[index]['inStock'],
          );
        },
      ),
    );
  }
}
