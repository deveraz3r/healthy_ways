import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/resources/app_colors.dart';

void showAssignMedicinePopup(String patientName, String medicineName) {
  Get.dialog(
    AssignMedicinePopup(patientName: patientName, medicineName: medicineName),
    barrierDismissible: false,
  );
}

class AssignMedicinePopup extends StatefulWidget {
  final String patientName;
  final String medicineName;

  const AssignMedicinePopup(
      {required this.patientName, required this.medicineName, super.key});

  @override
  _AssignMedicinePopupState createState() => _AssignMedicinePopupState();
}

class _AssignMedicinePopupState extends State<AssignMedicinePopup> {
  int quantity = 1;
  List<bool> selectedDays = List.generate(7, (index) => false);
  List<String> times = [];
  DateTime? endDate;

  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        times.add(picked.format(context));
      });
    }
  }

  void _selectEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ASSIGN MEDICINE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),

              // Patient Name Field
              _buildTextField(widget.patientName, "Patient Name"),
              const SizedBox(height: 10),

              // Medicine Name Field
              _buildTextField(widget.medicineName, "Medicine Name"),
              const SizedBox(height: 10),

              // Quantity Selector
              Row(
                children: [
                  const Text("QUANTITY",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text(quantity.toString(),
                      style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Day Selection
              Wrap(
                spacing: 5,
                children: List.generate(7, (index) {
                  return ChoiceChip(
                    label: Text(days[index]),
                    selected: selectedDays[index],
                    selectedColor: AppColors.primaryColor,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDays[index] = selected;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),

              // Time Selection
              Wrap(
                spacing: 8,
                children: times.map((time) {
                  return Chip(
                    label: Text(time),
                    onDeleted: () {
                      setState(() {
                        times.remove(time);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _selectTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Text("Add Time",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 15),

              // End Date Picker
              Row(
                children: [
                  const Text("END DATE",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    endDate != null
                        ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                        : "Select Date",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: _selectEndDate,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Cancel & Done Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Medicine Assignment Logic Here
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text("Done",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String value, String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      controller: TextEditingController(text: value),
    );
  }
}
