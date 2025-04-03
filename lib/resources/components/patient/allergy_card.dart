import 'package:flutter/material.dart';
import 'package:healty_ways/model/allergy_model.dart';
import 'package:healty_ways/view_model/health_records_view_model.dart';
import 'package:get/get.dart';

class AllergyCard extends StatelessWidget {
  const AllergyCard({super.key, required this.allergy});

  final AllergyModel allergy;

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
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                allergy.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                allergy.description,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () async {
              await _healthRecordVM.deleteAllergy(allergy.id);
            },
            icon: Icon(
              Icons.delete,
              size: 18,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
