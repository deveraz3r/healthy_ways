import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:healty_ways/view_model/doctors_view_model.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key});

  @override
  _DoctorProfileViewState createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();
  // final DoctorsViewModel _doctorsVM = Get.find<DoctorsViewModel>();  //TODO: maybe move doc functions to profileview
  final DoctorsViewModel _doctorsVM = Get.put(DoctorsViewModel());

  // Track expanded/collapsed state of sections
  final Map<String, bool> _sectionExpandedState = {
    "Personal Information": false,
    "Appointment Hours": false,
    "Account settings": false,
    "Password & Security": false,
    "Notification Settings": false,
  };

  // Track editing state for each field
  final Map<String, bool> _fieldEditingState = {
    "name": false,
    "email": false,
    "specialty": false,
    "qualification": false,
    "bio": false,
  };

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Local copy of weekly schedule to allow editing before saving
  late Map<String, List<AppointmentSlot>> _localWeeklySchedule;

  // Days of the week
  final List<String> _days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeWeeklySchedule();
  }

  void _initializeControllers() {
    final doctor = _profileVM.getRoleData<DoctorModel>();
    if (doctor != null) {
      _nameController.text = doctor.fullName;
      _emailController.text = doctor.email;
      _specialtyController.text = doctor.specialty;
      _qualificationController.text = doctor.qualification;
      _bioController.text = doctor.bio ?? '';
    }
  }

  // Create a local copy of the doctor's weekly schedule. If any day is missing, initialize it as an empty list.
  void _initializeWeeklySchedule() {
    final doctor = _profileVM.getRoleData<DoctorModel>();
    _localWeeklySchedule = {};
    for (var day in _days) {
      if (doctor != null && doctor.weeklySchedule.containsKey(day)) {
        _localWeeklySchedule[day] =
            List<AppointmentSlot>.from(doctor.weeklySchedule[day]!);
      } else {
        _localWeeklySchedule[day] = <AppointmentSlot>[];
      }
    }
  }

  void _updateProfile({
    String? fullName,
    String? email,
    String? specialty,
    String? qualification,
    String? bio,
  }) {
    final doctor = _profileVM.getRoleData<DoctorModel>();
    if (doctor == null) return;

    _profileVM.updateProfile(DoctorModel(
      uid: doctor.uid,
      fullName: fullName ?? doctor.fullName,
      email: email ?? doctor.email,
      profileImage: doctor.profileImage,
      qualification: qualification ?? doctor.qualification,
      specialty: specialty ?? doctor.specialty,
      location: doctor.location,
      bio: bio ?? doctor.bio,
      ratings: doctor.ratings,
      weeklySchedule: doctor.weeklySchedule,
      assignedPatients: doctor.assignedPatients,
    ));
  }

  // Save the local weekly schedule to Firebase
  void _saveAppointmentHours() {
    _doctorsVM.updateDoctorSchedule(_localWeeklySchedule);
    Get.snackbar("Success", "Appointment hours updated successfully!");
  }

  // Add a new appointment slot for a given day
  Future<void> _addAppointmentSlot(String day) async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Slot for $day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  startTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {}); // Refresh dialog
                },
                child: Text(startTime != null
                    ? "Start: ${_formatTime(startTime!)}"
                    : "Pick Start Time"),
              ),
              ElevatedButton(
                onPressed: () async {
                  endTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {});
                },
                child: Text(endTime != null
                    ? "End: ${_formatTime(endTime!)}"
                    : "Pick End Time"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (startTime != null && endTime != null) {
                  setState(() {
                    _localWeeklySchedule[day]!.add(
                      AppointmentSlot(startTime: startTime!, endTime: endTime!),
                    );
                  });
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                      "Error", "Please select both start and end times");
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Remove an appointment slot from a given day
  void _removeAppointmentSlot(String day, AppointmentSlot slot) {
    setState(() {
      _localWeeklySchedule[day]!.remove(slot);
    });
  }

  // Format TimeOfDay in 12-hour format
  String _formatTime(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();
    _qualificationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "My Profile",
        enableBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final doctor = _profileVM.getRoleData<DoctorModel>();
              if (doctor == null) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      doctor.profileImage ?? "assets/images/profile.jpg",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doctor.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sections
                  buildSectionTitle("EDIT DETAILS"),
                  buildExpandableSection(
                    title: "Personal Information",
                    children: [
                      buildEditableField(
                        label: "Name",
                        value: doctor.fullName,
                        controller: _nameController,
                        fieldKey: "name",
                        onSave: (newValue) =>
                            _updateProfile(fullName: newValue),
                      ),
                      buildEditableField(
                        label: "Email",
                        value: doctor.email,
                        controller: _emailController,
                        fieldKey: "email",
                        onSave: (newValue) => _updateProfile(email: newValue),
                      ),
                      buildEditableField(
                        label: "Specialty",
                        value: doctor.specialty,
                        controller: _specialtyController,
                        fieldKey: "specialty",
                        onSave: (newValue) =>
                            _updateProfile(specialty: newValue),
                      ),
                      buildEditableField(
                        label: "Qualification",
                        value: doctor.qualification,
                        controller: _qualificationController,
                        fieldKey: "qualification",
                        onSave: (newValue) =>
                            _updateProfile(qualification: newValue),
                      ),
                      buildEditableField(
                        label: "Bio",
                        value: doctor.bio ?? '',
                        controller: _bioController,
                        fieldKey: "bio",
                        onSave: (newValue) => _updateProfile(bio: newValue),
                      ),
                    ],
                  ),
                  buildExpandableSection(
                    title: "Appointment Hours",
                    children: [
                      _buildAppointmentHoursSection(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildSectionTitle("GENERAL SETTINGS"),
                  buildListTile(
                    icon: Icons.settings,
                    title: "Account settings",
                    onTap: () {},
                  ),
                  buildListTile(
                    icon: Icons.lock,
                    title: "Password & Security",
                    onTap: () {},
                  ),
                  buildListTile(
                    icon: Icons.notifications,
                    title: "Notification Settings",
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  ReuseableElevatedbutton(
                    buttonName: "Sign Out",
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAllNamed(RouteName.login);
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentHoursSection() {
    return Column(
      children: [
        for (var day in _days) _buildDayScheduleCard(day),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _saveAppointmentHours,
          child: const Text("Save Appointment Hours"),
        ),
      ],
    );
  }

  Widget _buildDayScheduleCard(String day) {
    final slots = _localWeeklySchedule[day] ?? [];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          ListTile(
            title:
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addAppointmentSlot(day),
            ),
          ),
          if (slots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No slots set"),
            )
          else
            Column(
              children: slots.map((slot) {
                return ListTile(
                  title: Text(
                      "${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeAppointmentSlot(day, slot),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget buildExpandableSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(title),
        trailing: Icon(
          _sectionExpandedState[title] == true
              ? Icons.arrow_drop_down
              : Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        initiallyExpanded: _sectionExpandedState[title] ?? false,
        onExpansionChanged: (expanded) {
          setState(() {
            _sectionExpandedState[title] = expanded;
          });
        },
        children: children,
      ),
    );
  }

  Widget buildEditableField({
    required String label,
    required String value,
    required TextEditingController controller,
    required String fieldKey,
    required Function(String) onSave,
  }) {
    final bool isEditing = _fieldEditingState[fieldKey] ?? false;

    return ListTile(
      title: isEditing
          ? TextField(
              controller: controller..text = value,
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    setState(() {
                      _fieldEditingState[fieldKey] = false;
                      onSave(controller.text);
                    });
                  },
                ),
              ),
            )
          : Text("$label: $value"),
      trailing: !isEditing
          ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _fieldEditingState[fieldKey] = true;
                });
              },
            )
          : null,
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
