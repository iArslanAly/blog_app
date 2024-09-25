import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Future<String> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  });
  Future<String> logInWithEmailPassword({
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
  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailPassword({
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
        return response.user!.id;
      }
    } catch (e) {
      throw Exception(e).toString();
    }
  }
}
