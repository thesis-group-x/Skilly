// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'fourth.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
           width: 400,
              height: 400,
              child: Lottie.asset(
                'assets/animations/mp.json',
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Monetize Your Skills ! \n Enter Skilly's Thriving Marketplace",
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            // Next and Previous buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FourthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF284855), 
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF284855), 
                  radius: 6.0,
                ),
                SizedBox(width: 5.0),
                CircleAvatar(
                  backgroundColor: Color(0xFF284855), 
                  radius: 6.0,
                ),
                SizedBox(width: 5.0),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 6.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
