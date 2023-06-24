import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'market/components/utils/api.dart';

class EditProfilePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onProfileUpdated;

  EditProfilePage({required this.onProfileUpdated});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      try {
        final response = await http.get(
          Uri.parse('http://${localhost}:3001/user/uid/$uid'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _phoneNumberController.text = userData['phoneNumber'] ?? '';
          _isLoading = false;
        } else {
          // Handle error case
          // Show an error message or perform any other necessary action
          print('Error fetching user data: ${response.body}');
        }
      } catch (error) {
        // Handle error case
        // Show an error message or perform any other necessary action
        print('Error fetching user data: $error');
      }
    }
  }

  void updateUser() async {
    // Check if any field is updated
    if (_nameController.text.isEmpty &&
        _emailController.text.isEmpty &&
        _addressController.text.isEmpty &&
        _phoneNumberController.text.isEmpty &&
        _passwordController.text.isEmpty) {
      // No fields are updated
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    print('User: $user');
    if (user != null) {
      final uid = user.uid;
      print('User ID: $uid');

      // Prepare the request body
      final body = {};

      if (_nameController.text.isNotEmpty) {
        body['name'] = _nameController.text;
      }

      if (_emailController.text.isNotEmpty) {
        body['email'] = _emailController.text;
      }

      if (_addressController.text.isNotEmpty) {
        body['address'] = _addressController.text;
      }

      if (_phoneNumberController.text.isNotEmpty) {
        body['phoneNumber'] = _phoneNumberController.text;
      }

      if (_passwordController.text.isNotEmpty) {
        body['password'] = _passwordController.text;
      }

      print('Request Body: $body');

      try {
        final response = await http.put(
          Uri.parse('http://${localhost}:3001/user/upd/$uid'),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'},
        );

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final updatedUser = json.decode(response.body);
          widget.onProfileUpdated(updatedUser);
          Navigator.pop(context);
        } else {
          // Handle error case
          // Show an error message or perform any other necessary action
          print('Error updating user: ${response.body}');
        }
      } catch (error) {
        // Handle error case
        // Show an error message or perform any other necessary action
        print('Error updating user: $error');
      }
    }
  }

  void logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (error) {
      print('Error logging out user: $error');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF284855),
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: () => logoutUser(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF284855),
                ),
              ),
              SizedBox(height: 15),
              buildTextField(
                  "username", "Enter your username", _nameController),
              buildTextField("Email", "Enter your email", _emailController),
              buildTextField(
                "Password",
                "Enter your password",
                _passwordController,
                isPassword: true,
              ),
              buildTextField(
                  "Location", "Enter your location", _addressController),
              buildTextField(
                "Number",
                "Enter your PhoneNumber",
                _phoneNumberController,
              ),
              SizedBox(height: 35),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF284855),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: updateUser,
                child: Text(
                  "SAVE",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF284855), // Set the hint text color
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid $labelText.';
          }
          return null;
        },
      ),
    );
  }
}
