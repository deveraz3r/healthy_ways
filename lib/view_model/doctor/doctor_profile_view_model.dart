import 'package:get/get.dart';
import 'package:healty_ways/model/doctor/doctor_profile_model.dart';

class DoctorProfileViewModel extends GetxController {
  // Observable profile object
  Rx<DoctorProfileModel> profile = DoctorProfileModel(
    name: "Junaid Ahmed",
    email: "Junaid@gmail.com",
    specality: "Developer",
    qualification: "BSCS",
    bio: "A professional app and web developer",
    profileImage: "assets/images/profile.jpg",
    avilableAppointmentHours: [],
  ).obs;

  // Function to update the entire profile
  void updateProfile(DoctorProfileModel updatedProfile) {
    profile.value = updatedProfile;
  }

  // Function to update the name
  void updateName(String newName) {
    profile.value.name = newName;
  }

  // Function to update the email
  void updateEmail(String newEmail) {
    profile.value.email = newEmail;
  }

  // Function to update the specialty
  void updateSpecialty(String newSpecialty) {
    profile.value.specality = newSpecialty;
  }

  // Function to update the qualification
  void updateQualification(String newQualification) {
    profile.value.qualification = newQualification;
  }

  // Function to update the bio
  void updateBio(String newBio) {
    profile.value.bio = newBio;
  }

  // Function to update the profile image
  void updateProfileImage(String newProfileImage) {
    profile.value.profileImage = newProfileImage;
  }

  // Function to update the available appointment hours
  void updateAvailableAppointmentHours(List<DateTime> newHours) {
    profile.value.avilableAppointmentHours = newHours;
  }
}
