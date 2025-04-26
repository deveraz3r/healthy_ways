import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:healty_ways/model/patient_model.dart';

class PatientProfileView extends StatefulWidget {
  const PatientProfileView({super.key});

  @override
  _PatientProfileViewState createState() => _PatientProfileViewState();
}

class _PatientProfileViewState extends State<PatientProfileView> {
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  // Track expanded/collapsed state of sections
  final Map<String, bool> _sectionExpandedState = {
    "Personal Information": false,
    "Account settings": false,
    "Password & Security": false,
    "Notification Settings": false,
  };

  // Track editing state for each field
  final Map<String, bool> _fieldEditingState = {
    "name": false,
    "email": false,
    "bio": false,
  };

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final patient = _profileVM.profile as PatientModel;
    _nameController.text = patient.fullName;
    _emailController.text = patient.email;
    _bioController.text = patient.bio ?? '';
  }

  void _updateProfile({
    String? fullName,
    String? email,
    String? bio,
  }) {
    final patient = _profileVM.profile as PatientModel;

    _profileVM.updateProfile(PatientModel(
      uid: patient.uid,
      fullName: fullName ?? patient.fullName,
      email: email ?? patient.email,
      profileImage: patient.profileImage,
      bio: bio ?? patient.bio,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
              final patient = _profileVM.profile as PatientModel;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      patient.profileImage ?? "assets/images/profile.jpg",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    patient.fullName,
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
                        value: patient.fullName,
                        controller: _nameController,
                        fieldKey: "name",
                        onSave: (newValue) =>
                            _updateProfile(fullName: newValue),
                      ),
                      buildEditableField(
                        label: "Email",
                        value: patient.email,
                        controller: _emailController,
                        fieldKey: "email",
                        onSave: (newValue) => _updateProfile(email: newValue),
                      ),
                      buildEditableField(
                        label: "Bio",
                        value: patient.bio ?? '',
                        controller: _bioController,
                        fieldKey: "bio",
                        onSave: (newValue) => _updateProfile(bio: newValue),
                      ),
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
                      Get.delete<AuthViewModel>();
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
