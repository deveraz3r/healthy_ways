import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/utils/app_urls.dart';

class PharmacistModel extends UserModel {
  PharmacistModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.role,
    super.profileImage,
  });

  // Convert to JSON for Firestore or local storage
  @override
  Map<String, dynamic> toJson() {
    final userJson = super.toJson();
    return {
      ...userJson,
    };
  }

  // Create PharmacistModel from JSON
  factory PharmacistModel.fromJson(Map<String, dynamic> json) {
    final baseUser = UserModel.fromJson(json);

    return PharmacistModel(
      uid: baseUser.uid,
      fullName: baseUser.fullName,
      email: baseUser.email,
      role: baseUser.role,
      profileImage: baseUser.profileImage,
    );
  }
}
