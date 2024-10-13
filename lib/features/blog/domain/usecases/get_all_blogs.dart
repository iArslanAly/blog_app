import 'package:fpdart/fpdart.dart';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepositories blogRepositories;
  GetAllBlogs(this.blogRepositories);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return blogRepositories.getAllBlogs();
  }
}
