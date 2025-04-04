enum UserRole { doctor, patient, pharmacist }

extension UserRoleExtension on UserRole {
  String get value => toString().split('.').last;
}

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final UserRole role;
  final String? profileImage;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'role': role.toString().split('.').last, // Store enum as string
        'profileImage': profileImage,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle role conversion from string to enum
    UserRole role;
    try {
      role = UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.patient, // Default value if not found
      );
    } catch (e) {
      role = UserRole.patient; // Fallback value
    }

    return UserModel(
      uid: json['uid'] as String? ?? '',
      fullName:
          json['name'] as String? ?? json['fullName'] as String? ?? 'No Name',
      email: json['email'] as String? ?? '',
      role: role,
      profileImage: json['profileImage'] as String?,
    );
  }
}
