class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final int? roleId;
  final bool isActive;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.roleId,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role_id'],
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role_id': roleId,
        'is_active': isActive,
      };
}