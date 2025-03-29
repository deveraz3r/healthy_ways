import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class SignupView extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "HEALTHY WAYS",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),

                // Role Selection Buttons
                Obx(
                  () => ToggleButtons(
                    isSelected: [
                      _authViewModel.selectedRole.value == UserRole.doctor,
                      _authViewModel.selectedRole.value == UserRole.patient,
                      _authViewModel.selectedRole.value == UserRole.pharmacist,
                    ],
                    onPressed: (int index) {
                      _authViewModel.selectedRole.value =
                          UserRole.values[index];
                    },
                    borderRadius: BorderRadius.circular(20),
                    selectedColor: Colors.black,
                    fillColor: Colors.white,
                    color: Colors.white,
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Doctor"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Patient"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Pharmacy"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Name Input
                ReusableTextField(
                  controller: _nameController,
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  onChanged: (value) => _authViewModel.name.value = value,
                ),

                const SizedBox(height: 10),

                // Email Input
                ReusableTextField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  onChanged: (value) => _authViewModel.email.value = value,
                ),

                const SizedBox(height: 10),

                // Password Input
                Obx(
                  () => ReusableTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    obscureText: _obscurePassword.value,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => _obscurePassword.toggle(),
                    ),
                    onChanged: (value) => _authViewModel.password.value = value,
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password Input
                Obx(
                  () => ReusableTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: _obscureConfirmPassword.value,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => _obscureConfirmPassword.toggle(),
                    ),
                    onChanged: (value) =>
                        _authViewModel.confirmPassword.value = value,
                  ),
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                Obx(() => ReuseableElevatedbutton(
                      buttonName: "Sign Up",
                      color: Colors.black,
                      // isLoading: _authViewModel.loading.value,
                      onPressed: () async {
                        if (_validateInputs()) {
                          final success = await _authViewModel.signUp();
                          if (success) {
                            _navigateToHomeScreen();
                          }
                        }
                      },
                    )),

                const SizedBox(height: 4),

                // Login Button
                ReuseableElevatedbutton(
                  buttonName: "Already have an account? Login",
                  borderColor: Colors.white,
                  color: Colors.transparent,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (_authViewModel.name.value.isEmpty) {
      Get.snackbar("Error", "Please enter your name");
      return false;
    }
    if (_authViewModel.email.value.isEmpty ||
        !_authViewModel.email.value.isEmail) {
      Get.snackbar("Error", "Please enter a valid email");
      return false;
    }
    if (_authViewModel.password.value.isEmpty ||
        _authViewModel.password.value.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return false;
    }
    if (_authViewModel.password.value != _authViewModel.confirmPassword.value) {
      Get.snackbar("Error", "Passwords don't match");
      return false;
    }
    return true;
  }

  void _navigateToHomeScreen() {
    switch (_authViewModel.selectedRole.value) {
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
}
