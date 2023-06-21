import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'market/components/utils/api.dart';
import 'user-profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import './feed/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'loading.dart';

void main() {
  runApp(MaterialApp(
    home: Complete(),
  ));
}

class Complete extends StatefulWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  String _selectedGender = 'Gender';
  String _selectedLocation = 'Location';
  String? _imageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  File? _selectedImage;

  Future<void> sendUpdateRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    print(FirebaseAuth.instance.currentUser);

    if (user != null) {
      final userId = user.email;
      final String name = nameController.text;
      final int age = int.tryParse(ageController.text) ?? 0;
      final String gender = _selectedGender;
      final String location = _selectedLocation;
      final String bio = detailsController.text;

      Future<void> sendUpdateRequest() async {
        // Check if all fields are filled
        if (name.isEmpty ||
            age <= 0 ||
            gender == 'Gender' ||
            location == 'Location' ||
            bio.isEmpty) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Missing Information'),
              content: const Text('Please fill in all the fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
          //  Exit the function if any information is missing
        }
      }

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'name': name,
        'age': age,
        'gender': gender,
        'address': location,
        'details': bio,
      };

      if (_imageUrl != null) {
        requestBody['imageUrl'] = _imageUrl;
        // Add the image URL to the request body
      }

      final response = await http.put(
        Uri.parse('http://$localhost:3001/up/updateuser/$userId'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Update successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Update failed
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Update Failed'),
            content: const Text('Unable to update user profile.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> uploadImageToCloudinary(File imageFile) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers['X-Upload-Preset'] = 'kusldcryyyyy';
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.transform(utf8.decoder).join();
      final data = json.decode(responseData);
      setState(() {
        _imageUrl = data['secure_url']; // Update the _imageUrl variable
      });
    } else {
      // Image upload failed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Image Upload Failed'),
          content: const Text('Unable to upload the selected image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      await uploadImageToCloudinary(
          _selectedImage!); // Upload the selected image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA), // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Complete your profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color(0xFF284855),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color(0xFF284855),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                    ),
                    hintText: 'Age',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color(0xFF284855),
                    width: 0.5,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.group,
                      color: Colors.black,
                    ),
                    hintText: 'Select your gender',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  value: _selectedGender,
                  items: <String>['Gender', 'Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue ?? '';
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color(0xFF284855),
                    width: 0.5,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    hintText: 'Select your location',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  value: _selectedLocation,
                  items: <String>[
                    'Location', // Add a default value if needed
                    '🇦🇫 Afghanistan',
                    '🇦🇱 Albania',
                    // Add more locations here
                    '🇻🇳 Vietnam',
                    '🇾🇪 Yemen',
                    '🇿🇲 Zambia',
                    '🇿🇼 Zimbabwe',
                  ]
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLocation = newValue ?? '';
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color(0xFF284855),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: detailsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSetupPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF284855),
                  ),
                  child: const Text('Complete'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
