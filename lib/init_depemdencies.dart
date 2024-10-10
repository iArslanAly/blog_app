import 'package:blog_app/core/secrets/app_supabase.dart';
import 'package:blog_app/features/auth/data/dataSources/auth_supabase_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user__log_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  final supabaseClient = await Supabase.initialize(
    url: AppSupabase.supabaseUrl,
    anonKey: AppSupabase.supabaseAnonKey,
    debug: true,
  );
  serviceLocator.registerLazySingleton(() => supabaseClient.client);
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<AuthSupabaseDataSource>(
        () => AuthSupabaseDAtaSourceImplementation(serviceLocator()))
    // Repositories
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    // Usecses
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignnUp: serviceLocator(),
          userLogIn: serviceLocator(),
          currentUser: serviceLocator(),
        ));
}
