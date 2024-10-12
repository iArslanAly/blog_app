import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {
              // Navigator.of(context).pushNamed(Routes.blogPage);
            },
            icon: const Icon(Icons.done_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
            //  image != null
              //    ? Image.file(image!)
                  GestureDetector(
                //      onTap: () {
                //        selectImage();
                 //     },
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
                  children: [
                    'Technology',
                    'Business',
                    'Prpgramming',
                    'Entertainment',
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(e),
                            side:
                                const BorderSide(color: AppPallete.borderColor),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              BlogEditor(controller: titleController, hintText: 'Blog Title'),
              const SizedBox(height: 10),
              BlogEditor(controller: contentController, hintText: 'Content')
            ],
          ),
        ),
      ),
    );
  }
}
