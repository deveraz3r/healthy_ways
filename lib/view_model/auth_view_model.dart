import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { doctor, patient, pharmacist }

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rxn<User> _user = Rxn<User>();

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

  Future<bool> signUp() async {
    try {
      loading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name.value,
        'email': email.value,
        'role': selectedRole.value.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
      });

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
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Fetch and set user role after login
      final userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      if (userDoc.exists) {
        final roleString = userDoc.data()?['role'] ?? 'patient';
        selectedRole.value = UserRole.values.firstWhere(
          (e) => e.toString().split('.').last == roleString,
          orElse: () => UserRole.patient,
        );
      }

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
