import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'feed/feed.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  bool showFirstAnimation = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      setState(() {
        showFirstAnimation = false;
      });
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Feed()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showFirstAnimation)
              Lottie.asset(
                'assets/animations/w8.json',
                width: 500,
                height: 500,
                fit: BoxFit.contain,
                repeat: true,
              )
            else
              Lottie.asset(
                'assets/animations/success.json',
                width: 500,
                height: 500,
                fit: BoxFit.contain,
              ),
            SizedBox(height: 20),
            Text(
              showFirstAnimation
                  ? 'Setting up your profile\nPlease hang tight!'
                  : "You're all set!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
