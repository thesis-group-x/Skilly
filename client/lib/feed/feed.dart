import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const Feed());

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const HomePage(),
      
    );
    
  }
}
