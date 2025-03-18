import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty_ways/view_model/patient/patient_profile_view_model.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileViewModel _profileViewModel = Get.put(ProfileViewModel());

  // Reactive user object
  final Rx<User?> _user = Rx<User?>(null);

  // Getter for the user
  User? get user => _user.value;

  // Check if the user is logged in
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    // Listen for authentication state changes
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
      if (user != null) {
        _profileViewModel.fetchProfile(user.uid); // Fetch profile data
      } else {
        _profileViewModel.clearProfile(); // Clear profile data on logout
      }
    });
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user.value = userCredential.user; // Update the reactive user
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  // Log in with email and password
  Future<void> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user.value = userCredential.user; // Update the reactive user
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  // Log out
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user.value = null; // Clear the reactive user
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
