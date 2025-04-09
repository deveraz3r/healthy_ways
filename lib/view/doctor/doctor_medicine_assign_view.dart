import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/medicine_schedule_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/resources/widgets/reusable_elevated_button.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:healty_ways/view_model/assigned_medication_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';

class DoctorMedicineAssignView extends StatefulWidget {
  const DoctorMedicineAssignView({super.key});

  @override
  State<DoctorMedicineAssignView> createState() =>
      _DoctorMedicineAssignViewState();
}

class _DoctorMedicineAssignViewState extends State<DoctorMedicineAssignView> {
  final AssignedMedicationViewModel assignedVM = Get.find();
  final ProfileViewModel _profileVM = Get.find();
  final AppointmentsViewModel _appointmentsVM = Get.find();
  final String patientId = Get.arguments['patientId'];
  final String patientName = Get.arguments['patientName'];
  final String appointmentId = Get.arguments['appointmentId'];

  @override
  void initState() {
    super.initState();
    assignedVM.fetchAvailableMedicines();
  }

  void _showMedicinePickerDialog(BuildContext context) {
    final searchController = TextEditingController();
    var filtered = assignedVM.availableMedicines.toList();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Medicine"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search medicine",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      setDialogState(() {
                        filtered = assignedVM.availableMedicines
                            .where((med) => med.name
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    width: 300,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final med = filtered[i];
                        return ListTile(
                          title: Text(med.name),
                          subtitle: Text('${med.formula} - ${med.stockType}'),
                          onTap: () {
                            assignedVM.addSchedule(MedicineScheduleModel(med));
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(MedicineScheduleModel sched) async {
    DateTime startDate = sched.startDate;
    DateTime endDate = sched.endDate;
    List<TimeOfDay> times = List.from(sched.times);

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Schedule for ${sched.medicine.name}"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                          "Start: ${DateFormat.yMMMd().format(startDate)}"),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setStateDialog(() => startDate = picked);
                        }
                      },
                    ),
                    ListTile(
                      title: Text("End: ${DateFormat.yMMMd().format(endDate)}"),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: startDate,
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setStateDialog(() => endDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: times.asMap().entries.map((entry) {
                        final formatted = entry.value.format(context);
                        return ListTile(
                          title: Text("Time ${entry.key + 1}: $formatted"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setStateDialog(() => times.removeAt(entry.key));
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: const Text("Add Time"),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setStateDialog(() => times.add(picked));
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    sched.startDate = startDate;
                    sched.endDate = endDate;
                    sched.times = times;
                    assignedVM.updateSchedule(sched);
                    Get.back();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Assign Medication to $patientName",
        enableBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showMedicinePickerDialog(context),
          )
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: assignedVM.selectedSchedules.length,
                  itemBuilder: (context, index) {
                    final sched = assignedVM.selectedSchedules[index];
                    return Card(
                      child: ListTile(
                        title: Text(sched.medicine.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From ${DateFormat.yMMMd().format(sched.startDate)} "
                              "to ${DateFormat.yMMMd().format(sched.endDate)}",
                            ),
                            Wrap(
                              spacing: 6,
                              children: sched.times.map((t) {
                                final formatted = DateFormat.jm().format(
                                  DateTime(0, 0, 0, t.hour, t.minute),
                                );
                                return Chip(label: Text(formatted));
                              }).toList(),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDialog(sched),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => assignedVM.removeSchedule(sched),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ReuseableElevatedbutton(
                onPressed: () async {
                  assignedVM.assignSchedulesToFirestore(
                    patientId: patientId,
                    doctorId: _profileVM.profile!.uid,
                    patientName: patientName,
                  );
                  await _appointmentsVM
                      .completeAppointmentWithReport(appointmentId);
                },
                buttonName: "Assign Medications",
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
