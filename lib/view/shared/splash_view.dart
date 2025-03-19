import 'package:google_fonts/google_fonts.dart';
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
      Get.offNamed(RouteName.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Image.asset(
              "assets/images/logo.png",
              height: 160,
            ),
            // Icon(Icons.medical_services, size: 80, color: Colors.white),

            SizedBox(height: 16),

            // App Name or Tagline
            Text(
              "HEALTY WAYS",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
