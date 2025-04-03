import 'package:flutter/material.dart';
import 'package:healty_ways/model/user_model.dart';

class DoctorModel extends UserModel {
  final String qualification;
  final String specialty;
  final String location;
  final String? bio;
  final List<RatingModel> ratings;
  final Map<String, List<AppointmentSlot>> weeklySchedule; // New format
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
    Map<String, List<AppointmentSlot>>? weeklySchedule,
    List<String>? assignedPatients,
  })  : ratings = ratings ?? [],
        weeklySchedule = weeklySchedule ?? {},
        assignedPatients = assignedPatients ?? [];

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'qualification': qualification,
        'specialty': specialty,
        'location': location,
        'bio': bio,
        'ratings': ratings.map((r) => r.toJson()).toList(),
        'weeklySchedule': weeklySchedule.map((day, slots) => MapEntry(
            day, slots.map((slot) => slot.toJson()).toList())), // Store as JSON
        'assignedPatients': assignedPatients,
      };

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      uid: json['uid'] as String? ?? '',
      fullName:
          json['fullName'] as String? ?? json['name'] as String? ?? 'No Name',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      qualification: json['qualification'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      location: json['location'] as String? ?? '',
      bio: json['bio'] as String?,
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((r) => RatingModel.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      weeklySchedule: (json['weeklySchedule'] as Map<String, dynamic>?)?.map(
            (day, slots) => MapEntry(
                day,
                (slots as List<dynamic>)
                    .map((slot) => AppointmentSlot.fromJson(slot))
                    .toList()),
          ) ??
          {},
      assignedPatients: (json['assignedPatients'] as List<dynamic>?)
              ?.map((p) => p.toString())
              .toList() ??
          [],
    );
  }
}

class AppointmentSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  AppointmentSlot({required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() => {
        'startTime': _formatTime(startTime),
        'endTime': _formatTime(endTime),
      };

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
    );
  }

  static String _formatTime(TimeOfDay time) {
    return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}";
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(' ');
    final hourMinute = parts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    if (parts[1] == 'PM' && hour != 12) hour += 12;
    if (parts[1] == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
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
