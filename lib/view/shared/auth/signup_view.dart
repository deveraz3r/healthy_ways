import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class SignupView extends StatelessWidget {
  final AuthViewModel _authVM = Get.find<AuthViewModel>();
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

                // Role Selection Buttons - Only this needs Obx since it uses selectedRole
                Obx(() => ToggleButtons(
                      isSelected: [
                        _authVM.selectedRole.value == UserRole.doctor,
                        _authVM.selectedRole.value == UserRole.patient,
                        _authVM.selectedRole.value == UserRole.pharmacist,
                      ],
                      onPressed: (int index) {
                        _authVM.selectedRole.value = UserRole.values[index];
                      },
                      borderRadius: BorderRadius.circular(20),
                      selectedColor: Colors.black,
                      fillColor: Colors.white,
                      color: Colors.white,
                      textStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
                          child: Text("Pharmacist"),
                        ),
                      ],
                    )),

                const SizedBox(height: 20),

                // Name Input
                ReusableTextField(
                  controller: _nameController,
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  onChanged: (value) => _authVM.name.value = value,
                ),

                const SizedBox(height: 10),

                // Email Input
                ReusableTextField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  onChanged: (value) => _authVM.email.value = value,
                ),

                const SizedBox(height: 10),

                // Password Input - Needs Obx for _obscurePassword
                Obx(() => ReusableTextField(
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
                      onChanged: (value) => _authVM.password.value = value,
                    )),

                const SizedBox(height: 10),

                // Confirm Password Input - Needs Obx for _obscureConfirmPassword
                Obx(() => ReusableTextField(
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
                          _authVM.confirmPassword.value = value,
                    )),

                const SizedBox(height: 20),

                // Sign Up Button - Needs Obx for loading state
                Obx(() => ReuseableElevatedbutton(
                      buttonName: "Sign Up",
                      color: Colors.black,
                      isLoading: _authVM.loading.value,
                      onPressed: () async {
                        if (await _validateInputs()) {
                          final success = await _authVM.signUp();
                          if (success) {
                            _authVM.navigateToHomeScreen();
                          }
                        }
                      },
                    )),

                const SizedBox(height: 4),

                // Login Button - Doesn't need Obx as it's static
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

  Future<bool> _validateInputs() async {
    if (_authVM.name.value.isEmpty) {
      Get.snackbar("Error", "Please enter your name");
      return false;
    }
    if (_authVM.email.value.isEmpty || !_authVM.email.value.isEmail) {
      Get.snackbar("Error", "Please enter a valid email");
      return false;
    }
    if (_authVM.password.value.isEmpty || _authVM.password.value.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return false;
    }
    if (_authVM.password.value != _authVM.confirmPassword.value) {
      Get.snackbar("Error", "Passwords don't match");
      return false;
    }

    // Check if email exists
    final emailExists = await _authVM.isEmailExists(_authVM.email.value);
    if (emailExists) {
      Get.snackbar("Error", "Email already registered");
      return false;
    }

    return true;
  }
}
