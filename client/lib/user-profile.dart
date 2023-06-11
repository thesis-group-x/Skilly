import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<dynamic> posts = [];
  List<dynamic> reviews = [];
  bool showAllPosts = false;
  bool showAllReviews = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchPosts();
    fetchReviews();
    fetchUserFeedPosts();
    fetchUserMarketPosts();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3001/user/byid/1'));
      final userData = json.decode(response.body);

      setState(() {
        imagePath = userData['profileImage'];
        name = userData['name'];
        email = userData['email'];
        numberOfPosts = userData['posts'].length;
        numberOfMatches = userData['memberships'].length;
        level = userData['level'];
      });
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed'));
      final postData = json.decode(response.body);

      setState(() {
        posts = postData['data'];
      });
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3001/market'));
      final marketData = json.decode(response.body);

      setState(() {
        reviews = marketData['data'];
      });
    } catch (error) {
      print('Error fetching reviews: $error');
    }
  }

  Future<void> fetchUserFeedPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3001/user/1/feed/posts'));
      final feedPostsData = json.decode(response.body);

      setState(() {
        posts = feedPostsData['data'];
      });
    } catch (error) {
      print('Error fetching user feed posts: $error');
    }
  }

  Future<void> fetchUserMarketPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3001/user/1/market/posts'));
      final marketPostsData = json.decode(response.body);

      setState(() {
        posts = marketPostsData['data'];
      });
    } catch (error) {
      print('Error fetching user market posts: $error');
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
    final visiblePosts = showAllPosts ? posts : posts.take(3).toList();

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
        SizedBox(height: 8),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: visiblePosts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(visiblePosts[index]['title']),
            );
          },
        ),
        buildShowMoreButton(posts.length > 3),
        buildShowLessButton(showAllPosts),
      ],
    );
  }

  Widget buildReviewsSection() {
    final visibleReviews = showAllReviews ? reviews : reviews.take(3).toList();

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
        SizedBox(height: 8),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: visibleReviews.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(visibleReviews[index]['title']),
            );
          },
        ),
        buildShowMoreButton(reviews.length > 3),
        buildShowLessButton(showAllReviews),
      ],
    );
  }

  Widget buildShowMoreButton(bool visible) {
    return Visibility(
      visible: visible,
      child: TextButton(
        onPressed: () {
          setState(() {
            if (showAllPosts) {
              showAllReviews = true;
            } else {
              showAllPosts = true;
            }
          });
        },
        child: Text(
          'Show More',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget buildShowLessButton(bool visible) {
    return Visibility(
      visible: visible,
      child: TextButton(
        onPressed: () {
          setState(() {
            if (showAllPosts) {
              showAllReviews = false;
            } else {
              showAllPosts = false;
            }
          });
        },
        child: Text(
          'Show Less',
          style: TextStyle(
            color: Colors.blue,
          ),
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