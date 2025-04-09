import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class PharmacistProfileView extends StatefulWidget {
  const PharmacistProfileView({super.key});

  @override
  _PharmacistProfileViewState createState() => _PharmacistProfileViewState();
}

class _PharmacistProfileViewState extends State<PharmacistProfileView> {
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  // Track expanded/collapsed state
  final Map<String, bool> _sectionExpandedState = {
    "Personal Information": false,
    "Security": false,
  };

  // Track editing state
  final Map<String, bool> _fieldEditingState = {
    "name": false,
    "email": false,
  };

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final pharmacist = _profileVM.getRoleData<PharmacistModel>();
    if (pharmacist != null) {
      _nameController.text = pharmacist.fullName;
      _emailController.text = pharmacist.email;
    }
  }

  void _updateProfile({String? fullName, String? email}) {
    final pharmacist = _profileVM.getRoleData<PharmacistModel>();
    if (pharmacist == null) return;

    _profileVM.updateProfile(PharmacistModel(
      uid: pharmacist.uid,
      fullName: fullName ?? pharmacist.fullName,
      email: email ?? pharmacist.email,
      role: pharmacist.role,
      profileImage: pharmacist.profileImage,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Pharmacist Profile",
        enableBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final pharmacist = _profileVM.getRoleData<PharmacistModel>();
              if (pharmacist == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: pharmacist.profileImage != null
                        ? NetworkImage(pharmacist.profileImage!)
                        : const AssetImage("assets/images/profile.jpg")
                            as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pharmacist.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pharmacist.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Personal Information Section
                  buildSectionTitle("PERSONAL INFORMATION"),
                  buildExpandableSection(
                    title: "Edit Profile",
                    children: [
                      buildEditableField(
                        label: "Full Name",
                        value: pharmacist.fullName,
                        controller: _nameController,
                        fieldKey: "name",
                        onSave: (newValue) =>
                            _updateProfile(fullName: newValue),
                      ),
                      buildEditableField(
                        label: "Email",
                        value: pharmacist.email,
                        controller: _emailController,
                        fieldKey: "email",
                        onSave: (newValue) => _updateProfile(email: newValue),
                      ),
                    ],
                  ),

                  // Security Section
                  const SizedBox(height: 10),
                  buildSectionTitle("SECURITY"),
                  buildListTile(
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {}, // Add password change logic
                  ),
                  buildListTile(
                    icon: Icons.logout,
                    title: "Sign Out",
                    onTap: () {
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

  // Reusable Widgets
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
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
              icon: const Icon(Icons.edit, size: 20),
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
