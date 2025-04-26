import "package:healty_ways/utils/app_urls.dart";

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rxn<User> _user = Rxn<User>();

  final ProfileViewModel _profileVM =
      Get.put(ProfileViewModel(), permanent: true);

  // Form fields
  final Rx<UserRole> selectedRole = UserRole.patient.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool loading = false.obs;
  final RxBool obscurePassword = true.obs;

  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<bool> isEmailExists(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      Get.snackbar("Error", "Failed to check email existence");
      return true; // Assume exists to prevent creation on error
    }
  }

  Future<bool> signUp() async {
    try {
      // Check if email already exists
      if (await isEmailExists(email.value)) {
        Get.snackbar("Error", "Email already registered with another account");
        return false;
      }

      loading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Create basic user data
      final userData = {
        'uid': userCredential.user?.uid,
        'name': name.value,
        'email': email.value,
        'role': selectedRole.value.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add role-specific fields if needed
      if (selectedRole.value == UserRole.doctor) {
        userData.addAll({
          'qualification': '',
          'specialty': '',
          'location': '',
          'ratings': [],
          'availableTimes': [],
          'assignedPatients': [],
        });
      }
      // Add other role-specific fields as needed

      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userData);

      // Initialize profile after signup
      await _profileVM.fetchProfile(
        userCredential.user!.uid,
        selectedRole.value,
      );

      return true;
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      loading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.uid == null) {
        throw Exception("User UID is null");
      }

      // Fetch user document
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        await _auth.signOut();
        Get.snackbar("Error", "User document not found");
        return false;
      }

      final data = userDoc.data()!;

      // Validate required fields
      if (data['email'] == null || data['role'] == null) {
        await _auth.signOut();
        Get.snackbar("Error", "User data is incomplete");
        return false;
      }

      // Get the stored role
      final roleString = data['role'] as String;
      final storedRole = UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == roleString,
        orElse: () => UserRole.patient,
      );

      // Check if selected role matches stored role
      if (storedRole != selectedRole.value) {
        await _auth.signOut();
        Get.snackbar(
          "Login Failed",
          "This email is registered as a ${roleString.capitalizeFirst}, not as a ${selectedRole.value.toString().split('.').last.capitalizeFirst}",
        );
        return false;
      }

      // Update selected role
      selectedRole.value = storedRole;

      // Initialize profile with the correct role model
      await _profileVM.fetchProfile(userCredential.user!.uid, storedRole);

      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Authentication error");
      return false;
    } catch (e) {
      Get.snackbar("Login Failed", "An unexpected error occurred");
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    selectedRole.value = UserRole.patient; // Reset role on logout
    Get.offAll(RouteName.login);
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent");
    } catch (e) {
      Get.snackbar("Error", "Failed to send reset email: ${e.toString()}");
    }
  }

  void navigateToHomeScreen() async {
    await initViewModels(); // Ensure view models are initialized
    switch (selectedRole.value) {
      case UserRole.doctor:
        Get.offAllNamed(RouteName.doctorHomeView);
        break;
      case UserRole.patient:
        Get.offAllNamed(RouteName.patientHome);
        break;
      case UserRole.pharmacist:
        Get.offAllNamed(RouteName.pharmacyHomeView);
        break;
    }
  }

  Future<void> initViewModels() async {
    // Initialize the view models in the correct order
    // Get.put(AuthViewModel()); // Auth must be initialized first
    // Get.put(ProfileViewModel()); // Profile depends on Auth

    // 2. Now put all other VMs that depend on profile
    Get.put(MedicineViewModel(), permanent: true);
    Get.put(InventoryViewModel(), permanent: true);
    Get.put(PatientsViewModel(), permanent: true);
    Get.put(DoctorsViewModel(), permanent: true);
    Get.put(PharmacistsViewModel(), permanent: true);
    Get.put(AssignedMedicationViewModel(), permanent: true);
    Get.put(AppointmentsViewModel(), permanent: true);
    Get.put(ChatViewModel(), permanent: true);
    Get.put(HealthRecordsViewModel(), permanent: true);
    Get.put(OrderViewModel(), permanent: true);
    Get.put(LabReportsViewModel(), permanent: true);

    // // Initialize independent view models
    // Get.put(MedicineViewModel()); // Independent
    // Get.put(InventoryViewModel()); // Depends on Profile

    // // Initialize user-specific view models
    // Get.put(PatientsViewModel()); // Depends on Profile
    // Get.put(DoctorsViewModel()); // Depends on Profile
    // Get.put(PharmacistsViewModel()); // Depends on Profile
    // // Ensure AssignedMedicationViewModel completes initialization
    // final AssignedMedicationViewModel assignedMedicationVM =
    //     Get.put(AssignedMedicationViewModel());
    // assignedMedicationVM
    //     .fetchAssignedMedication(Get.find<ProfileViewModel>().profile!.uid);

    // // Initialize other dependent view models
    // Get.put(AppointmentsViewModel()); // Independent but after Profile
    // Get.put(ChatViewModel()); // Depends on Profile
    // Get.put(HealthRecordsViewModel()); // Depends on Profile
    // Get.put(OrderViewModel()); // Depends on Profile
    // Get.put(LabReportsViewModel()); // Depends on Profile
  }
}
