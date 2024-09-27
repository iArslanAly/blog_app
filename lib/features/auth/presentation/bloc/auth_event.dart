part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String name;
  final String password;
  final String email;

  AuthSignUp({
    required this.name,
    required this.password,
    required this.email,
  });
}
