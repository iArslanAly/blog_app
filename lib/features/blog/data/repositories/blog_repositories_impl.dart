import 'dart:io';

import 'package:blog_app/core/connection/internet_checker.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_locl_datasource.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';

class BlogRepositoriesImpl implements BlogRepositories {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoriesImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Future.value(Left(Failure(message: 'No internet connection')));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v4(),
        posterId: posterId,
        title: title,
        content: content,
        topics: topics,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );
      final imageUrl =
          await blogRemoteDataSource.uploadImage(image: image, blog: blogModel);
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uplodedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return Future.value(Right(uplodedBlog));
    } on ServerExceptions catch (e) {
      return Future.value(Left(Failure(message: e.message)));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final localBlogs = blogLocalDataSource.loadBlogs();
        return Future.value(Right(localBlogs));
      }
      final blogs = await blogRemoteDataSource.getAllBlog();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return Future.value(Right(blogs));
    } on ServerExceptions catch (e) {
      return Future.value(Left(Failure(message: e.message)));
    }
  }
}
