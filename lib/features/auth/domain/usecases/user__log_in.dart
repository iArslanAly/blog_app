import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn {
  final AuthRepository repository;
  UserLogIn(this.repository);

  Future<Either<Failure, String>> call(UserLogInParams params) async {
    return await repository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLogInParams {
  final String password;
  final String email;
  UserLogInParams({
    required this.password,
    required this.email,
  });
}
