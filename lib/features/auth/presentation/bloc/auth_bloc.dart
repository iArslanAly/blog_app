import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user__log_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserSignUp userSignnUp,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
  })  : _userSignUp = userSignnUp,
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }
  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _currentUser(NoParams());
    response.fold(
      (l) => emit(AuthFailuer(l.message)),
      (r) {
        print(r.id);
        emit(AuthSuccess(r));
      },
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignUp(UserSignUpParams(
        name: event.name, password: event.password, email: event.email));
    response.fold((failure) => emit(AuthFailuer(failure.message)),
        (user) => emit(AuthSuccess(user)));
  }

  void _onAuthLogIn(AuthLogIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogIn(
        UserLogInParams(password: event.password, email: event.email));
    response.fold((failure) => emit(AuthFailuer(failure.message)),
        (user) => emit(AuthSuccess(user)));
  }
}
