import 'package:flutter/material.dart';
import './landing pages/welcome.dart';

void main() {
  runApp(const SkillyApp());
}

class SkillyApp extends StatelessWidget {
  const SkillyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skilly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      home:  const LandingPage(),
    );
  }
}
