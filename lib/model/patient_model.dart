import 'package:healty_ways/model/user_model.dart';

class PatientModel extends UserModel {
  final String? bio;

  PatientModel({
    required super.uid,
    required super.fullName,
    required super.email,
    super.profileImage,
    this.bio,
  });

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'bio': bio,
      };

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        uid: json['uid'] ?? '',
        fullName: json['fullName'] ?? json['name'] ?? 'No Name',
        email: json['email'] ?? '',
        profileImage: json['profileImage'],
        bio: json['bio'],
      );
}
