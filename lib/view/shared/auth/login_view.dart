import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healty_ways/resources/app_colors.dart';
import 'package:healty_ways/resources/components/reusable_elevated_button.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/shared/auth_view_model.dart';

class LoginView extends StatelessWidget {
  final AuthViewModel _authViewModel = Get.put(AuthViewModel());

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

                // Email Input
                TextField(
                  decoration: InputDecoration(
                    hintText: "Doctor134@gmail.com",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Password Input
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign In Button
                ReuseableElevatedbutton(
                  buttonName: "Sign In",
                  color: Colors.black,
                  onPressed: () {
                    Get.offAllNamed(RouteName.patientHome);
                  },
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
