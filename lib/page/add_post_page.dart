// views/add_post_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utills/AppColors.dart';
import '../Utills/widgets/rich_text_input.dart';
import '../controller/community/community_controller.dart';
import '../models/community_post_model.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final controller = Get.find<CommunityController>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              RichTextInput(
                controller: _descriptionController,
                hintText: 'Description',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {_submitPost(); },
                    child: Text("Add Community Post"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().app_primary,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      final newPost = CommunityPost(
        title: _titleController.text,
        description: _descriptionController.text,
        imagePath: _imageController.text,
      );

      controller.createPost(newPost).then((_) {
        Get.back();
      });
    }
  }
}