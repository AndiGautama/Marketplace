part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;
  const LoginButtonPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class RegisterButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  const RegisterButtonPressed({required this.email, required this.password, required this.fullName});
  @override
  List<Object> get props => [email, password, fullName];
}

class ForgotPasswordResetRequested extends AuthEvent {
  final String email;
  const ForgotPasswordResetRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class LogoutButtonPressed extends AuthEvent {}