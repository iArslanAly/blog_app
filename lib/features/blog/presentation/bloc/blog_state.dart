part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);
}

final class BlogSuccess extends BlogState {
  // ignore: prefer_typing_uninitialized_variables
  final success;

  BlogSuccess(this.success);
}
