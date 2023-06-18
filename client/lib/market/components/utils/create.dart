import 'dart:convert';
import 'dart:io';

import 'package:client/market/market.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import '../market.dart';

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

  List<File> _images = [];

  Future<void> _getImages() async {
    final imagePicker = ImagePicker();

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

      final postUrl = Uri.parse('http://${localhost}:3001/Market/posts');
      final data = {
        'price': int.parse(_priceController.text),
        'title': _titleController.text,
        'description': _descriptionController.text,
        'skill': _skillController.text,
        'userId': int.parse('1'),
        'image': imageUrls,
      };
      print(data);
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
