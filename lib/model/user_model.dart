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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        fullName: json['fullName'],
        email: json['email'],
        profileImage: json['profileImage'],
      );
}
