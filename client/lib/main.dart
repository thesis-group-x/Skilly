import 'package:flutter/material.dart';
import 'market.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace life',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Market(),
    );
  }
}
