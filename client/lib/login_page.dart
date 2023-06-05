// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        // Login successful, perform any additional logic here
        print('User ID: ${userCredential.user!.uid}');
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Login error: $e');
    }
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
                'assets/images/login.png',
                width: 250.0,
                height: 250.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Welcome Back!',
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
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
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.046),
              SizedBox(
                width: 211,
                height: 46,
                child: ElevatedButton(
                  onPressed: _loginUser,
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
                    child: const Text('Login'),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: const Text('Don’t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}