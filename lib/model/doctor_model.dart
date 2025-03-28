import 'package:healty_ways/model/ratting_model.dart';
import 'package:healty_ways/model/user_model.dart';

class DoctorModel extends UserModel {
  final String qualification;
  final String specialty;
  final String? bio;
  final List<RatingModel> ratings;
  final List<DateTime> availableTimes;
  final List<String> assignedPatients;

  DoctorModel({
    required super.uid,
    required super.fullName,
    required super.email,
    super.profileImage,
    required this.qualification,
    required this.specialty,
    this.bio,
    List<RatingModel>? ratings,
    List<DateTime>? availableTimes,
    List<String>? assignedPatients,
  })  : ratings = ratings ?? [],
        availableTimes = availableTimes ?? [],
        assignedPatients = assignedPatients ?? [];

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'qualification': qualification,
        'specialty': specialty,
        'bio': bio,
        'ratings': ratings.map((r) => r.toJson()).toList(),
        'availableTimes':
            availableTimes.map((t) => t.toIso8601String()).toList(),
        'assignedPatients': assignedPatients,
      };

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        uid: json['uid'],
        fullName: json['fullName'],
        email: json['email'],
        profileImage: json['profileImage'],
        qualification: json['qualification'],
        specialty: json['specialty'],
        bio: json['bio'],
        ratings: (json['ratings'] as List<dynamic>?)
                ?.map((r) => RatingModel.fromJson(r))
                .toList() ??
            [],
        availableTimes: (json['availableTimes'] as List<dynamic>?)
                ?.map((t) => DateTime.parse(t))
                .toList() ??
            [],
        assignedPatients: (json['assignedPatients'] as List<dynamic>?)
                ?.map((p) => p.toString())
                .toList() ??
            [],
      );
}
