import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/dataSources/auth_supabase_data_source.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  late final AuthSupabaseDataSource supabaseDataSource;

  AuthRepositoryImpl(this.supabaseDataSource);

  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() => supabaseDataSource.logInWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String email,
      required String name,
      required String password}) async {
    return _getUser(() => supabaseDataSource.signUpWithEmailPassword(
          email: email,
          name: name,
          password: password,
        ));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return Future.value(right(user));
    } on sb.AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerExceptions catch (e) {
      return Future.value(left(Failure(message: e.message)));
    }
  }

  @override
  Future<Either<Failure, User?>> currentUser() async {
    try {
      final user = await supabaseDataSource.getcurrentUseData();
      if (user == null) {
        return left(Failure(message: 'User is null'));
      } else {
        return right(user);
      }
    } on ServerExceptions catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
