import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './landing pages/welcome.dart';
import 'market/market.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SkillyApp());
}

class SkillyApp extends StatelessWidget {
  const SkillyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skilly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
