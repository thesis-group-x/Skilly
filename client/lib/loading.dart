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
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showFirstAnimation = false;
      });
      Future.delayed(Duration(seconds: 3), () {
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
              Lottie.network(
                'https://lottie.host/3730cd1a-809c-4fe8-a699-25f4372454d4/gyaqRk3Xpa.json',
                width: 500,
                height: 500,
                fit: BoxFit.contain,
                repeat: true,
              )
            else
              Lottie.network(
                'https://lottie.host/6014f0a3-3313-4af9-aca2-b77bbea01d88/KXQq3C2yUE.json',
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
