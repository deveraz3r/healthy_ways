import 'package:flutter/material.dart';

// SIGNUP PAGE
class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool _obscurePassword = true;

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
            Text("Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Sign up to get started",
                style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 24),

            // Name Input
            buildTextField("Full Name", Icons.person, false),

            SizedBox(height: 16),

            // Email Input
            buildTextField("Email", Icons.email, false),

            SizedBox(height: 16),

            // Password Input
            buildTextField("Password", Icons.lock, true),

            SizedBox(height: 24),

            // Signup Button
            buildButton("SIGN UP", Colors.teal, () {
              // Handle signup logic
            }),

            SizedBox(height: 16),

            // Already have an account?
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Already have an account? Login",
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
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
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
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
