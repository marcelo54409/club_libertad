class User {
  late final String username;
  final int id;
  final String email;
  final String accessToken;

  User({
    this.username = "",
    required this.id,
    required this.email,
    required this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['user']['username'] ?? '',
      id: json['user']['id'],
      email: json['user']['email'] ?? '',
      accessToken: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'email': email,
      'accessToken': accessToken,
    };
  }

  @override
  String toString() {
    return 'User{username: $username, id: $id, email: $email, accessToken: $accessToken';
  }
}
