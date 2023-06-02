import 'package:flutter/material.dart';

import 'interests_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',

      home: InterestsPage(), // Set InterestsPage as the initial page
    );
  }
}
