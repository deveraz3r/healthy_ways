import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class LoginView extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());
  final RxBool _obscurePassword = true.obs;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

                const SizedBox(height: 20),

                // Sign In Button
                Obx(() => ReuseableElevatedbutton(
                      buttonName: "Sign In",
                      color: Colors.black,
                      // isLoading: _authViewModel.loading.value,
                      onPressed: () async {
                        final success = await _authViewModel.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (success) {
                          _navigateToHomeScreen();
                        }
                      },
                    )),

                const SizedBox(height: 4),

                // Create Account Button
                ReuseableElevatedbutton(
                  buttonName: "Create new account",
                  borderColor: Colors.white,
                  color: Colors.transparent,
                  onPressed: () => Get.toNamed(RouteName.signup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
