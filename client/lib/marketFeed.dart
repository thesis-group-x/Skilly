import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return PostItem();
        },
      ),
    );
  }
}

class PostItem extends StatefulWidget {
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int likesCount = 0;
  int commentsCount = 0;
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likesCount--;
      } else {
        likesCount++;
      }
      isLiked = !isLiked;
    });
  }

  void addComment() {
    setState(() {
      commentsCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile picture
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
          SizedBox(height: 8),
          // Post image
          Image.asset(
            'assets/post_image.png',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          // Likes and comments count
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: toggleLike,
              ),
              Text('$likesCount Likes'),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: addComment,
              ),
              Text('$commentsCount Comments'),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedPage(),
    );
  }
}
