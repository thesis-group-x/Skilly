import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'second.dart';
import 'third.dart';
import 'fourth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PagesNav(),
    );
  }
}

class PagesNav extends StatefulWidget {
  const PagesNav({Key? key}) : super(key: key);

  @override
  _PagesNavState createState() => _PagesNavState();
}

class _PagesNavState extends State<PagesNav> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const [
          SecondPage(),
          ThirdPage(),
          FourthPage(),
        ],
      ),
    );
  }
}
