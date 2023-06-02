// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool showNearbyPeople = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Page'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 2 || index == 5) {
            return ListTile(
              title: Text('Post $index'),
              subtitle: const Text('This is a post.'),
            );
          } else {
            return Container(
              height: 200,
              color: Colors.grey,
              margin: const EdgeInsets.all(8),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/anotherPage');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/thirdPage');
          }
        },
      ),
    );
  }
}
