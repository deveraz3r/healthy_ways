import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class DoctorProfileView extends StatefulWidget {
  @override
  _DoctorProfileViewState createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  final ProfileViewModel _profileVM = Get.put(ProfileViewModel());
  final String currentUserId = "current_user_id"; // Replace with actual user ID

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

  @override
  void initState() {
    super.initState();
    _profileVM.fetchProfile(currentUserId);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      _profileVM.profile['profileImage'] ??
                          "assets/images/profile.jpg",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    _profileVM.profile['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      value: _profileVM.profile['name'] ?? '',
                      controller: _nameController,
                      fieldKey: "name",
                      onSave: (newValue) {
                        _profileVM
                            .updateProfile(currentUserId, {'name': newValue});
                      },
                    ),
                    buildEditableField(
                      label: "Email",
                      value: _profileVM.profile['email'] ?? '',
                      controller: _emailController,
                      fieldKey: "email",
                      onSave: (newValue) {
                        _profileVM
                            .updateProfile(currentUserId, {'email': newValue});
                      },
                    ),
                    buildEditableField(
                      label: "Specialty",
                      value: _profileVM.profile['specialty'] ?? '',
                      controller: _specialtyController,
                      fieldKey: "specialty",
                      onSave: (newValue) {
                        _profileVM.updateProfile(
                            currentUserId, {'specialty': newValue});
                      },
                    ),
                    buildEditableField(
                      label: "Qualification",
                      value: _profileVM.profile['qualification'] ?? '',
                      controller: _qualificationController,
                      fieldKey: "qualification",
                      onSave: (newValue) {
                        _profileVM.updateProfile(
                            currentUserId, {'qualification': newValue});
                      },
                    ),
                    buildEditableField(
                      label: "Bio",
                      value: _profileVM.profile['bio'] ?? '',
                      controller: _bioController,
                      fieldKey: "bio",
                      onSave: (newValue) {
                        _profileVM
                            .updateProfile(currentUserId, {'bio': newValue});
                      },
                    ),
                  ],
                ),
                buildExpandableSection(
                  title: "Appointment Hours",
                  children: [
                    // Add appointment hours fields here
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget methods remain the same as in your original code
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
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
