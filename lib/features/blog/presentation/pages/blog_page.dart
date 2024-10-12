import 'package:blog_app/features/blog/presentation/pages/add_new_page.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(AddNewBlogPage.route());
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: const Center(
        child: Text('Blog Page'),
      ),
    );
  }
}
