import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:firebase_auth/firebase_auth.dart';

import 'bottom_navigation.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String imagePath = '';
  String name = '';
  String email = '';
  int numberOfPosts = 0;
  int numberOfMatches = 0;
  String level = '';

  final List<String> posts = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
    'Post 5',
    'Post 6',
    'Post 7',
    'Post 8',
    'Post 9',
    'Post 10',
    'Post 11',
    'Post 12',
  ];

  final List<String> reviews = [
    'Review 1',
    'Review 2',
    'Review 3',
    'Review 4',
    'Review 5',
    'Review 6',
    'Review 7',
    'Review 8',
    'Review 9',
    'Review 10',
    'Review 11',
    'Review 12',
  ];

  bool showAllPosts = false;
  bool showAllReviews = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
  final userId = 2;

  final response = await http.get(Uri.parse('http://10.0.2.2:3001/user/byid/$userId'));
  if (response.statusCode == 200) {
    final userData = json.decode(response.body);
    setState(() {
      name = userData['name'];
      email = userData['email'];
      numberOfPosts = userData['numberOfPosts'] ?? 0;
      numberOfMatches = userData['numberOfMatches'] ?? 0;
      level = userData['level'];
      imagePath = userData['profileImage'];
    });
  } else {
    throw Exception('Failed to fetch user information');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          buildProfileInfo(),
          SizedBox(height: 24),
          buildPostsSection(),
          SizedBox(height: 24),
          buildReviewsSection(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final icon = CupertinoIcons.moon_stars;

    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildProfileInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 64,
          backgroundImage: NetworkImage(imagePath ?? ''),
        ),
        SizedBox(height: 16),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(email),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildInfoItem('Posts', numberOfPosts.toString()),
            SizedBox(width: 32),
            buildInfoItem('Matches', numberOfMatches.toString()),
            SizedBox(width: 32),
            buildInfoItem('Level', level),
          ],
        ),
      ],
    );
  }

  Widget buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: showAllPosts ? posts.length : 3,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post),
            );
          },
        ),
        if (!showAllPosts && posts.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAllPosts = true;
                });
              },
              child: Text('Show all'),
            ),
          ),
      ],
    );
  }

  Widget buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: showAllReviews ? reviews.length : 3,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ListTile(
              title: Text(review),
            );
          },
        ),
        if (!showAllReviews && reviews.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAllReviews = true;
                });
              },
              child: Text('Show all'),
            ),
          ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'SKILLY',
    home: UserProfilePage(),
  ));
}