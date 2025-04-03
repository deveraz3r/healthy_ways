import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/immunization_model.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';

class ImmunizationCard extends StatelessWidget {
  const ImmunizationCard({super.key, required this.immunization});

  final ImmunizationModel immunization;

  @override
  Widget build(BuildContext context) {
    final HealthRecordsViewModel _healthRecordVM = Get.find();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  immunization.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  immunization.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await _healthRecordVM.deleteImmunization(immunization.id);
            },
            icon: Icon(Icons.delete, size: 18, color: Colors.red),
          )
        ],
      ),
    );
  }
}
