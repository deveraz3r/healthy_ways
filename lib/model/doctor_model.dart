import 'package:healty_ways/model/user_model.dart';

class DoctorModel extends UserModel {
  final String qualification;
  final String specialty;
  final String location;
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
    required this.location,
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
        'location': location,
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
        location: json['location'] ?? '',
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

class RatingModel {
  final String ratedBy;
  final int stars;
  final String? message;

  RatingModel({
    required this.ratedBy,
    required this.stars,
    this.message,
  });

  Map<String, dynamic> toJson() => {
        'ratedBy': ratedBy,
        'stars': stars,
        'message': message,
      };

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        ratedBy: json['ratedBy'],
        stars: json['stars'],
        message: json['message'],
      );
}
