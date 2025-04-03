import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class LoginView extends StatelessWidget {
  //AuthVM is permentant so it does not get auto destroy when poping the screen
  final AuthViewModel _authVM = Get.put(AuthViewModel(), permanent: true);

  LoginView({super.key});

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
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  onChanged: (value) => _authVM.email.value = value,
                ),
                const SizedBox(height: 10),

                // Password Input
                Obx(
                  () => ReusableTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    obscureText: _authVM.obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _authVM.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => _authVM.togglePasswordVisibility(),
                    ),
                    onChanged: (value) => _authVM.password.value = value,
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                Obx(
                  () => ReuseableElevatedbutton(
                    buttonName: "Sign In",
                    color: Colors.black,
                    isLoading: _authVM.loading.value,
                    onPressed: () async {
                      try {
                        final success = await _authVM.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (success) {
                          _authVM.navigateToHomeScreen();
                        }
                      } catch (e) {
                        // Errors are already handled in the ViewModel
                      }
                    },
                  ),
                ),
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
}
