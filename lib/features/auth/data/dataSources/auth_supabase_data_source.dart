import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  });
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthSupabaseDAtaSourceImplementation implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseDAtaSourceImplementation(
    this.supabaseClient,
  );
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
        throw ServerExceptions('Login failed');
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
}
