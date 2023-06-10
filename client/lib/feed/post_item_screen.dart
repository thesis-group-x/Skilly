import 'package:flutter/material.dart';
import '../bottom_navigation.dart';

class PostItemScreen extends StatelessWidget {
  final int postId;
  final String imageUrl;
  final String title;
  final String skill;
  final String description;
  final int likes;
  final int userId;

  const PostItemScreen({
    Key? key,
    required this.postId,
    required this.imageUrl,
    required this.title,
    required this.skill,
    required this.description,
    required this.likes,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // Add more details about the post using the available data
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Skill: $skill',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Likes: $likes',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // Display comments and reviews if needed
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: CustomBottomNavigation(
              currentIndex: 0,
              onTabSelected: (index) {
                // Handle bottom navigation button taps
              },
            ),
          ),
        ],
      ),
    );
  }
}
