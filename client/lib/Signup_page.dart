import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  bool _isPasswordVisible = false;

  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = "";
    });
    String fullName = _fullNameController.text;
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "All fields must be filled.";
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user?.updateProfile(displayName: fullName);
      user?.reload();

      Map<String, dynamic> userData = {
        'name': fullName,
        'email': email,
        'uid': user?.uid,
      };

      var response = await http.post(
        Uri.parse('http://10.0.2.2:3001/user/adduser'),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _fullNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        print('User created: ${response.body}');
        await _showSuccessDialog();
      } else {
        print('Error creating user: ${response.statusCode}');
        setState(() {
          _errorMessage = "Error creating user. Please try again later.";
        });
      }
    } catch (e) {
      print('Error creating user: $e');
      setState(() {
        _errorMessage = "Error creating user. Please try again later.";
      });
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Created'),
          content: Text('Your account has been created successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/signup.png',
                width: 250.0,
                height: 250.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 90, 90, 90),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0861),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0206),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0206),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Container(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.046),
              SizedBox(
                width: 211,
                height: 46,
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF284855),
                    onPrimary: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Sign Up'),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
