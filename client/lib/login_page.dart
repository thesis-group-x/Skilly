import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Signup_page.dart';
import 'interests_page.dart';
import './feed/feed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential != null) {
        // Login successful, navigate to InterestsPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Feed()),
        );
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Google sign-in error: $e');
    }
  }

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
        // Login successful, navigate to InterestsPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Feed()),
        );
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
              const SizedBox(height: 10.0),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.0106),
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
                    prefixIcon: Icon(Icons.lock),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.036),
              SizedBox(
                width: 211,
                height: 48,
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
         
              SizedBox(height: 14.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 GestureDetector(
  onTap: _signInWithGoogle,
  child: Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 207, 207, 207),
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: EdgeInsets.all(10.0),
    child: Row(
      children: [
        Image.asset(
          'assets/images/google.png',
          width: 28.0,
          height: 28.0,
        ),
SizedBox(
  width: 12.0,
  height: 6.0,
),


         Container(
              margin: EdgeInsets.only(right: 27.0),
             child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Color.fromARGB(255, 66, 66, 66),
                    fontSize: 15 ,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
         )
      ],
    ),
  ),
),

                ],
              ),
            const SizedBox(height: 8.0),
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  },
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(
            color: Colors.black, 
          ),
        ),
        TextSpan(
          text: "Sign up",
          style: TextStyle(
            color:  Color.fromARGB(255, 67, 120, 141), 
             fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
