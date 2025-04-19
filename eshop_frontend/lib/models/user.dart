class User {
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? role;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
