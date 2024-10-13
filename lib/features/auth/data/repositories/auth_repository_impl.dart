import 'package:blog_app/core/connection/internet_checker.dart';
import 'package:blog_app/core/constents/constents.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/dataSources/auth_supabase_data_source.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  late final AuthSupabaseDataSource supabaseDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(
    this.supabaseDataSource,
    this.connectionChecker,
  );

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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: Constants.noConnectionErrorMessage));
      }
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
      if (!await (connectionChecker.isConnected)) {
        final session = supabaseDataSource.currentUserSession;

        if (session == null) {
          return left(Failure(message: 'User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
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
