import 'package:flutter/material.dart';
import 'dart:async';

import 'package:healty_ways/utils/app_urls.dart';

// SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay of 3 seconds before moving to Login Page
    Timer(Duration(seconds: 3), () {
      Get.toNamed(RouteName.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(Icons.medical_services, size: 80, color: Colors.white),

            SizedBox(height: 16),

            // App Name or Tagline
            Text(
              "Health App",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),

            SizedBox(height: 8),

            // Loading Indicator
            // CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
