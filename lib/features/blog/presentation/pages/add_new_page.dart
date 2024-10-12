import 'dart:io';

import 'package:blog_app/core/common/loader.dart';
import 'package:blog_app/core/constents/constents.dart';
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ))),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(15),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 2,
                              child: const SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, size: 40),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Your Image',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                        controller: titleController, hintText: 'Blog Title'),
                    const SizedBox(height: 10),
                    BlogEditor(
                        controller: contentController, hintText: 'Content')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
