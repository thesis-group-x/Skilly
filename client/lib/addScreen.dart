import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'market/components/utils/create.dart';
import 'feed/pages/create_post.dart';
import 'bottom_navigation.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose where you want to post!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Lottie.asset(
              'assets/animations/add.json',
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostFeed()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF284855), 
              ),
              child: Text('Feed'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF284855), 
              ),
              child: Text('Marketplace'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 2,
        onTabSelected: (index) {
          
        },
      ),
    );
  }
}
