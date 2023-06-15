import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'api.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_image == null) {
      return;
    }

    final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dwtho2kip/upload';
    final cloudinaryPreset = 'kusldcry';

    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image!.path),
      'upload_preset': cloudinaryPreset,
    });

    try {
      final response = await dio.post(cloudinaryUrl, data: formData);
      final imageUrl = response.data['secure_url'];

      final postUrl = Uri.parse('http://${localhost}:3001/Market/posts');
      final data = {
        'price': int.parse(_priceController.text),
        'title': _titleController.text,
        'description': _descriptionController.text,
        'skill': _skillController.text,
        'userId': int.parse('1'),
        'image': imageUrl,
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
    } catch (error) {
      print('Error uploading image: $error');
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
              MaterialPageRoute(builder: (context) => CreatePostScreen()),
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
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
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
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Take Photo'),
            ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Choose from Gallery'),
            ),
            SizedBox(height: 16),
            if (_image != null) Image.file(_image!),
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
