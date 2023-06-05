// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'third.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/feed2.png'),
            const SizedBox(height: 20.0),
            const Text(
              "Ignite Your Inspiration: Explore Skilly's Dynamic Feed!",
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ThirdPage()),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF284855), // Change circle color here
                  radius: 6.0,
                ),
                SizedBox(width: 5.0),
                CircleAvatar(
                  backgroundColor: Colors.grey,
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
