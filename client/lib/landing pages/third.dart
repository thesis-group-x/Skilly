// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
            Image.asset('assets/images/market2.png'),
            const SizedBox(height: 20.0),
            const Text(
              "Monetize Your Skills: Enter Skilly's Thriving Marketplace!",
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF284855), 
                  ),
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FourthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF284855), // Change button color here
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
