import 'dart:convert';
import 'dart:io';

import 'package:client/market/market.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class CreatePostFeed extends StatefulWidget {
  @override
  _CreatePostFeedState createState() => _CreatePostFeedState();
}

class _CreatePostFeedState extends State<CreatePostFeed> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  List<File> _images = [];

  Future<void> _getImages() async {
    final imagePicker = ImagePicker();
    // ignore: unused_local_variable
    final currentUser = FirebaseAuth.instance.currentUser;
    List<XFile>? pickedImages = await imagePicker.pickMultiImage();

    setState(() {
      _images =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }

  Future<void> _createPost() async {
    if (_images.isEmpty) {
      return;
    }

    final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dwtho2kip/upload';
    final cloudinaryPreset = 'kusldcry';

    final dio = Dio();
    List<String> imageUrls = [];

    try {
      for (var imageFile in _images) {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(imageFile.path),
          'upload_preset': cloudinaryPreset,
        });

        final response = await dio.post(cloudinaryUrl, data: formData);
        final imageUrl = response.data['secure_url'];
        imageUrls.add(imageUrl);
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final apiUrl =
          'http://10.0.2.2:3001/user/uid/$uid'; // Replace with your API endpoint

      final apiResponse = await http.get(Uri.parse(apiUrl));
      print(apiResponse.body);
      if (apiResponse.statusCode == 200) {
        final userData = jsonDecode(apiResponse.body);
        // Store user data in a state or variable
        setState(() async {
          // Example: Storing user data in a user variable
          var user = userData;

          final postUrl = Uri.parse('http://10.0.2.2:3001/feed/post');
          final data = {
            'title': _titleController.text,
            'description': _descriptionController.text,
            'skill': _skillController.text,
            'userId': user['id'],
            'image': imageUrls,
          };

          final postResponse = await http.post(
            postUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          );

          if (postResponse.statusCode == 200) {
            final decodedPostResponse = jsonDecode(postResponse.body);
            print('Post created: $decodedPostResponse');
          } else {
            print('Error creating post: ${postResponse.statusCode}');
          }
        });
      } else {
        // Handle API error
      }
    } catch (error) {
      print('Error uploading images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _skillController,
              decoration: InputDecoration(labelText: 'Skill'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImages,
              child: Text('Select Photos'),
            ),
            SizedBox(height: 16),
            if (_images.isNotEmpty)
              SizedBox(
                height: 250.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _images[index],
                      height: 250.0,
                      width: 300 - 40.0,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
