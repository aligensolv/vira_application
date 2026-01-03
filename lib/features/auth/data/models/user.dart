import 'package:vira/core/utils/logger.dart';

class User {
  final int id;
  final String name;
  final String email;

  final DateTime joinedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    pinfo(json);
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      joinedAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': joinedAt.toIso8601String(),
    };
  }
}