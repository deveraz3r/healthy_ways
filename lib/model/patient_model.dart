import 'package:healty_ways/model/user_model.dart';

class Patient extends UserModel {
  Patient({
    required super.uid,
    required super.fullName,
    required super.email,
    super.profileImage,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        uid: json['uid'],
        fullName: json['fullName'],
        email: json['email'],
        profileImage: json['profileImage'],
      );
}
