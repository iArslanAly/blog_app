import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/data/model/data_sources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';

class BlogRepositoriesImpl implements BlogRepositories {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoriesImpl(this.blogRemoteDataSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
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
}
