class UserModel {
  final String name;
  final String username;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  // Factory constructor for creating a new UserModel instance from a map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  // Method for serializing UserModel instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
