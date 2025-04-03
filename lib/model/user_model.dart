class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String? profileImage;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'profileImage': profileImage,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '', // Handle null case
      fullName:
          json['name'] as String? ?? json['fullName'] as String? ?? 'No Name',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
    );
  }
}
