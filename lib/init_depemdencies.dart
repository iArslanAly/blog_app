import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_supabase.dart';
import 'package:blog_app/features/auth/data/dataSources/auth_supabase_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user__log_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/model/data_sources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repositories_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabaseClient = await Supabase.initialize(
    url: AppSupabase.supabaseUrl,
    anonKey: AppSupabase.supabaseAnonKey,
    debug: true,
  );
  serviceLocator.registerLazySingleton(() => supabaseClient.client);

  //Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
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
          appUserCubit: serviceLocator(),
        ));
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<BlogRepositories>(() => BlogRepositoriesImpl(
          serviceLocator(),
        ))
    // Usecses
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //Bloc
    ..registerLazySingleton(() => BlogBloc(
          uploadBlog: serviceLocator(),
          getAllBlogs: serviceLocator(),
        ));
}
