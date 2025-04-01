import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

enum UserRole { doctor, patient, pharmacist }

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rxn<User> _user = Rxn<User>();

  final ProfileViewModel _profileVM = Get.put(ProfileViewModel());

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

      // Fetch user document
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        Get.snackbar("Error", "User not found");
        return false;
      }

      // Get the stored role
      final roleString = userDoc.data()?['role'] ?? 'patient';
      final storedRole = UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == roleString,
        orElse: () => UserRole.patient,
      );

      // Check if selected role matches stored role
      if (storedRole != selectedRole.value) {
        await _auth.signOut();
        Get.snackbar(
          "Login Failed",
          "This email is registered as a $roleString, not as a ${selectedRole.value.toString().split('.').last}",
        );
        return false;
      }

      // Update selected role
      selectedRole.value = storedRole;

      // Initialize profile with the correct role model
      await _profileVM.fetchProfile(userCredential.user!.uid, storedRole);

      return true;
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    selectedRole.value = UserRole.patient; // Reset role on logout
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent");
    } catch (e) {
      Get.snackbar("Error", "Failed to send reset email: ${e.toString()}");
    }
  }
}
