import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  });
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getcurrentUseData();
}

class AuthSupabaseDAtaSourceImplementation implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseDAtaSourceImplementation(
    this.supabaseClient,
  );
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;
  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw ServerExceptions('User is Null');
      } else {
        return UserModel.fromJson(response.user!.toJson());
      }
    } catch (e) {
      throw Exception(e).toString();
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});
      if (response.user == null) {
        throw ServerExceptions('User is null');
      } else {
        return UserModel.fromJson(response.user!.toJson());
      }
    } catch (e) {
      throw Exception(e).toString();
    }
  }

  @override
  Future<UserModel?> getcurrentUseData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first);
      } else if (currentUserSession == null) {
        throw ServerExceptions('User is null');
      }
    } on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
    return null;
  }
}
