import 'package:flutter/material.dart';
import 'feed/feed.dart';
import './market/market.dart';
import 'user-profile.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  CustomBottomNavigation({
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF284855),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FeedPage()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
            break;
          case 2:
            break;
          case 3:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
              (route) => false,
            );
            break;
        }

        widget.onTabSelected(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Match',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

