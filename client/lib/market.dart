import 'package:flutter/material.dart';

void main() {
  runApp(const Market());
}

class Market extends StatelessWidget {
  const Market({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace is good',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MarketplaceFeed(),
    );
  }
}

class MarketplaceFeed extends StatelessWidget {
  const MarketplaceFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: Center(
        child: ListView(
          children: [
            // List items or posts
            ListTile(
              leading: Image.asset('assets/images/image2.jpg'),
              title: const Text('Item 1'),
              subtitle: const Text('Description 1'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), // Icon for posting a post
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
