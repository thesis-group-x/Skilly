import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'web.dart';

class WebAnimation extends StatefulWidget {
  @override
  _WebAnimationState createState() => _WebAnimationState();
}

class _WebAnimationState extends State<WebAnimation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Lottie.asset(
              'assets/animations/webdev.json',
              width: 500,
              height: 500,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF284855),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              child: Text(
                'Explore!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
