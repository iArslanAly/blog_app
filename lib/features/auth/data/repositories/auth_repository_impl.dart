import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/dataSources/auth_supabase_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final AuthSupabaseDataSource supabaseDataSource;

  AuthRepositoryImpl(this.supabaseDataSource);
  @override
  Future<Either<Failure, String>> logInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String email,
      required String name,
      required String password}) async {
    try {
      final userId = await supabaseDataSource.signUpWithEmailPassword(
        email: email,
        name: name,
        password: password,
      );
      return Future.value(right(userId));
    } on ServerExceptions catch (e) {
      return Future.value(left(Failure(message: e.message)));
    }
  }
}
