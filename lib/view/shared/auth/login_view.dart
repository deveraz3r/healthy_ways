import 'package:google_sign_in/google_sign_in.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view/patient/home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In Function
  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Successfully signed in
        print("Google Sign-In successful: ${googleUser.email}");
        Get.offAll(HomeView());
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Login to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 24),

            // Email Input
            buildTextField("Email", Icons.email, false),

            SizedBox(height: 16),

            // Password Input
            buildTextField("Password", Icons.lock, true),

            SizedBox(height: 24),

            // Login Button
            buildButton(
              "LOGIN",
              Colors.teal,
              () {
                // Handle login logic
                Get.offAll(HomeView());
              },
            ),

            SizedBox(height: 16),

            // Google Sign-In Button
            buildGoogleButton(),

            SizedBox(height: 16),

            // Don't Have an Account?
            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed(RouteName.signup);
                },
                child: Text("Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.teal)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Build TextField
  Widget buildTextField(String label, IconData icon, bool isPassword) {
    return TextField(
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }

  // Function to Build Button
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Function to Build Google Sign-In Button
  Widget buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey),
          ),
        ),
        icon: Image.asset("assets/images/google.png", height: 24),
        label: Text(
          "Login with Google",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
