import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation.dart'; 

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final String imagePath =
      'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=333&q=80';
  final String name = 'Sarah Abs';
  final String email = 'sarah.abs@gmail.com';
  final int numberOfPosts = 10; // Replace with the actual number of posts
  final int numberOfMatches = 5; // Replace with the actual number of matches
  final String level = 'Advanced'; // Replace with the actual level

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
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3, // Replace with the actual current index
        onTabSelected: (index) {
          // Handle tab selection here
        },
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
          backgroundImage: NetworkImage(imagePath),
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
        Text(
          email,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildInfoItem('Posts', numberOfPosts.toString()),
            SizedBox(width: 24),
            buildInfoItem('Matches', numberOfMatches.toString()),
            SizedBox(width: 24),
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
            fontSize: 20,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildPostsSection() {
    final displayedPosts = showAllPosts ? posts : posts.sublist(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Posts'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: displayedPosts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(displayedPosts[index]),
              // Customize the ListTile as per your post model
            );
          },
        ),
        buildShowMoreButton(
          visible: !showAllPosts,
          onPressed: () {
            setState(() {
              showAllPosts = true;
            });
          },
        ),
        buildShowLessButton(
          visible: showAllPosts,
          onPressed: () {
            setState(() {
              showAllPosts = false;
            });
          },
        ),
      ],
    );
  }

  Widget buildReviewsSection() {
    final displayedReviews = showAllReviews ? reviews : reviews.sublist(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Reviews'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: displayedReviews.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(displayedReviews[index]),
              // Customize the ListTile as per your review model
            );
          },
        ),
        buildShowMoreButton(
          visible: !showAllReviews,
          onPressed: () {
            setState(() {
              showAllReviews = true;
            });
          },
        ),
        buildShowLessButton(
          visible: showAllReviews,
          onPressed: () {
            setState(() {
              showAllReviews = false;
            });
          },
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildShowMoreButton({required bool visible, required VoidCallback onPressed}) {
    return Visibility(
      visible: visible,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Show More',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget buildShowLessButton({required bool visible, required VoidCallback onPressed}) {
    return Visibility(
      visible: visible,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Show Less',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'SKILLY',
    home: UserProfilePage(),
  ));
}
