import 'package:flutter/material.dart';
import 'feed/feed.dart';
import './market/market.dart';
import 'market/components/utils/create.dart';
// import 'feed/create_feed.dart';
import 'market/components/payment/payment.dart';
import 'user-profile.dart';
import 'package:client/chat pages/home.dart';

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
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: _currentIndex == 0 ? const Color(0xFF284855) : Colors.grey,
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
              widget.onTabSelected(0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Feed()),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: _currentIndex == 1 ? const Color(0xFF284855) : Colors.grey,
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
              widget.onTabSelected(1);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            color: _currentIndex == 2 ? const Color(0xFF284855) : Colors.grey,
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
              widget.onTabSelected(2);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChatApp()),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: _currentIndex == 3 ? const Color(0xFF284855) : Colors.grey,
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
              widget.onTabSelected(3);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PacksListWidget()),
                (route) => false,
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Create Market'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Create Feed'),
                  value: 1,
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(),
                  ),
                );
              } else if (value == 1) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CreateFeedScreen(),
                //   ),
                // );
              }
            },
          ),
        ],
      ),
    );
  }
}
