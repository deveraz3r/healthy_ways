class Profile {
  final String uid; // Unique ID of the user
  final String name;
  final String email;
  final String? profilePhotoUrl; // Optional profile photo URL
  final String? phoneNumber; // Optional phone number
  final String? address; // Optional address

  Profile({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    this.phoneNumber,
    this.address,
  });

  // Convert Profile object to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Create a Profile object from a Firebase document
  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      profilePhotoUrl: data['profilePhotoUrl'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
    );
  }
}
