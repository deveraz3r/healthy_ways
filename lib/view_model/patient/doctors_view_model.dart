import 'package:get/get.dart';
import 'package:healty_ways/model/patient/doctor.dart';

class DoctorViewModel extends GetxController {
  // List of doctors (reactive)
  final RxList<Doctor> doctors = <Doctor>[].obs;

  // Search query (reactive)
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load doctors when the ViewModel is initialized
    _loadDoctors();
  }

  // Simulate loading doctors (replace with API call in a real app)
  void _loadDoctors() {
    final List<Doctor> loadedDoctors = [
      Doctor(
        name: 'Dr. John Doe',
        profilePhoto: 'https://example.com/john_doe.jpg',
        rating: 4.5,
        qualification: 'MBBS, MD',
        specialty: 'Cardiologist',
      ),
      Doctor(
        name: 'Dr. Jane Smith',
        profilePhoto: 'https://example.com/jane_smith.jpg',
        rating: 4.8,
        qualification: 'MBBS, MS',
        specialty: 'Dermatologist',
      ),
      Doctor(
        name: 'Dr. Alice Johnson',
        profilePhoto: 'https://example.com/alice_johnson.jpg',
        rating: 4.7,
        qualification: 'MBBS, DNB',
        specialty: 'Pediatrician',
      ),
    ];

    doctors.assignAll(loadedDoctors); // Update the reactive list
  }
}
