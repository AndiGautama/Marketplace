import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [id, email];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
    );
  }
}