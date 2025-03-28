import 'package:get/get.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/ratting_model.dart';

class DoctorViewModel extends GetxController {
  final Rx<DoctorModel?> _currentDoctor = Rx<DoctorModel?>(null);
  DoctorModel? get currentDoctor => _currentDoctor.value;
  set currentDoctor(DoctorModel? value) => _currentDoctor.value = value;

  final RxList<DoctorModel> _doctors = <DoctorModel>[].obs;
  List<DoctorModel> get doctors => _doctors;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _doctors.addAll([
      DoctorModel(
        uid: 'doctor1',
        fullName: 'Dr. Smith',
        email: 'dr.smith@example.com',
        profileImage: 'https://example.com/dr_smith.jpg',
        qualification: 'MD, Cardiology',
        specialty: 'Cardiologist',
        bio: 'Experienced cardiologist with 10 years of practice',
        ratings: [
          RatingModel(
            ratedBy: 'patient1',
            stars: 5,
            message: 'Excellent doctor!',
          ),
        ],
        availableTimes: [
          DateTime.now().add(const Duration(days: 1)),
          DateTime.now().add(const Duration(days: 2)),
        ],
        assignedPatients: ['patient1', 'patient2'],
      ),
    ]);
  }

  void setCurrentDoctor(DoctorModel doctor) {
    currentDoctor = doctor;
  }

  void addDoctor(DoctorModel doctor) {
    _doctors.add(doctor);
  }

  void removeDoctor(String uid) {
    _doctors.removeWhere((doctor) => doctor.uid == uid);
  }

  void addRating(String doctorId, RatingModel rating) {
    final doctor = _doctors.firstWhere((d) => d.uid == doctorId);
    doctor.ratings.add(rating);
    _doctors.refresh();
  }
}
