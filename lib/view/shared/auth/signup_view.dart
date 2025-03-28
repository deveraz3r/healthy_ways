import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class SignupView extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

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
                      _authViewModel.selectedRole.value == "Doctor",
                      _authViewModel.selectedRole.value == "Patient",
                      _authViewModel.selectedRole.value == "Pharmacy",
                    ],
                    onPressed: (int index) {
                      switch (index) {
                        case 0:
                          _authViewModel.selectedRole.value = "Doctor";
                          break;
                        case 1:
                          _authViewModel.selectedRole.value = "Patient";
                          break;
                        case 2:
                          _authViewModel.selectedRole.value = "Pharmacy";
                          break;
                      }
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

                // Name Input with Leading Icon
                ReusableTextField(
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),

                const SizedBox(height: 10),

                // Email Input with Leading Icon
                ReusableTextField(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                ),

                const SizedBox(height: 10),

                // Password Input with Leading Icon and Trailing Visibility Toggle
                Obx(
                  () => ReusableTextField(
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
                      onPressed: () {
                        _obscurePassword.toggle();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password Input with Leading Icon and Trailing Visibility Toggle
                Obx(
                  () => ReusableTextField(
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
                      onPressed: () {
                        _obscureConfirmPassword.toggle();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                ReuseableElevatedbutton(
                  buttonName: "Sign Up",
                  color: Colors.black,
                  onPressed: () {
                    // Handle sign up logic
                    Get.offAllNamed(RouteName.patientHome);
                  },
                ),

                const SizedBox(height: 4),

                // Already have an account? Login Button
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
}
