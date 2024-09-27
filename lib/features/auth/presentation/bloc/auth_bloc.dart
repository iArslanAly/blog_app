import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({
    required UserSignUp userSignnUp,
  })  : _userSignUp = userSignnUp,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final response = await _userSignUp(UserSignUpParams(
          name: event.name, password: event.password, email: event.email));
      response.fold(
          (l) => emit(AuthFailuer(l.message)), (r) => emit(AuthSuccess(r)));
    });
  }
}
