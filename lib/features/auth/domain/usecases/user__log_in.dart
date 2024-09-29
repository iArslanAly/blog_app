import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn implements UseCase<User, UserLogInParams> {
  final AuthRepository authRepository;
  UserLogIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLogInParams params) async {
    return await authRepository.logInWithEmailPassword(
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
