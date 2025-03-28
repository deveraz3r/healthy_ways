import 'package:healty_ways/model/user_model.dart';

class PatientModel extends UserModel {
  PatientModel({
    required super.uid,
    required super.fullName,
    required super.email,
    super.profileImage,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        uid: json['uid'],
        fullName: json['fullName'],
        email: json['email'],
        profileImage: json['profileImage'],
      );
}
