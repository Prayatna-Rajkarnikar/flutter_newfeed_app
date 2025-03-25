import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:newsfeed_app/service/auth_provider.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  Future<void> _addPost(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      int? userId =
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).getUserIdFromToken();

      if (userId != null) {
        NewsPost newPost = NewsPost(
          id: 0,
          title: _titleController.text,
          body: _bodyController.text,
          userId: userId,
        );

        bool success = await Provider.of<AuthProvider>(
          context,
          listen: false,
        ).addPost(newPost);

        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Post added successfully!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to add post')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User not authenticated')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Body'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the body';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _addPost(context),
                child: Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
