import 'package:healty_ways/model/user_model.dart';

class PatientModel extends UserModel {
  final String? bio;

  PatientModel({
    required super.uid,
    required super.fullName,
    required super.email,
    super.profileImage,
    this.bio,
  }) : super(role: UserRole.patient);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'bio': bio,
      };

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      uid: json['uid'] as String? ?? '',
      fullName:
          json['fullName'] as String? ?? json['name'] as String? ?? 'No Name',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
