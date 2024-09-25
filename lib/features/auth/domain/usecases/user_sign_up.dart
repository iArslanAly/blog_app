// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
        email: params.email, name: params.name, password: params.password);
  }
}

class UserSignUpParams {
  final String name;
  final String password;
  final String email;
  UserSignUpParams({
    required this.name,
    required this.password,
    required this.email,
  });
}
