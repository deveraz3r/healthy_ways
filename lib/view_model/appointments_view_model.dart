import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/appointment_model.dart';

class AppointmentsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<AppointmentModel> _appointments = <AppointmentModel>[].obs;

  List<AppointmentModel> get appointments => _appointments;

  Future<void> fetchUserAppointments(String userId, bool isDoctor) async {
    final field = isDoctor ? 'doctorId' : 'patientId';
    final query = await _firestore
        .collection('appointments')
        .where(field, isEqualTo: userId)
        .orderBy('time')
        .get();

    _appointments.assignAll(query.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList());
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    await _firestore.collection('appointments').add(appointment.toJson());
    _appointments.add(appointment);
  }
}
