// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../Signup_page.dart';
import '../complete.dart';

class FourthPage extends StatelessWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/chat.png'),
            const SizedBox(height: 20.0),
            const Text(
              "Connect with Like-Minded Individuals: Let's Forge Meaningful Connections on Skilly!",
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
                      MaterialPageRoute(builder: (context) => const Complete ()),
                    );
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
                      MaterialPageRoute(builder: (context) => SignUpPage ()),
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
            // Progress indicators
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
                  backgroundColor: Color(0xFF284855), 
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
