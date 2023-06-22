import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'market/components/pages/welcome.dart';
import 'feed/feed.dart';
import 'user-profile.dart';
import 'package:client/chat pages/home.dart';
import 'market/components/utils/create.dart';
import 'feed/pages/create_post.dart';
import 'addScreen.dart';

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
    return CurvedNavigationBar(
      backgroundColor: Color(0xFF284855),
      index: _currentIndex,
      items: <Widget>[
        Icon(Icons.home_outlined, size: 30),
        Icon(Icons.shopping_cart_outlined, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.message_outlined, size: 30),
        Icon(Icons.person_2_outlined, size: 30),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onTabSelected(index);
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Feed()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
              (route) => false,
            );
            break;
          case 2:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => CreatePage()),
              (route) => false,
            );
            break;
          case 3:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ChatApp()),
              (route) => false,
            );
            break;
          case 4:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
              (route) => false,
            );
            break;
          default:
            break;
        }
      },
    );
  }

  void _handlePlusButtonClick() {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text('Create Market'),
          value: 0,
        ),
        PopupMenuItem(
          child: Text('Create Feed'),
          value: 1,
        ),
      ],
    ).then((value) {
      if (value == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePostScreen()),
        );
      } else if (value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePostFeed()),
        );
      }
    });
  }
}
