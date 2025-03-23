class DoctorProfileModel {
  String name;
  String email;
  String specality;
  String qualification;
  String bio;
  String profileImage;
  List<DateTime> avilableAppointmentHours;

  DoctorProfileModel({
    required this.name,
    required this.email,
    required this.specality,
    required this.qualification,
    required this.bio,
    required this.profileImage,
    required this.avilableAppointmentHours,
  });
}
