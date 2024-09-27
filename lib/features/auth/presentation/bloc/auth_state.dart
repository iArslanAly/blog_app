part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  late final String uid;
  AuthSuccess(this.uid);
}

final class AuthFailuer extends AuthState {
  late final String message;
  AuthFailuer(this.message);
}
