import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "bottom_navigation.dart";

void main() {
  runApp(const FeedApp());
}

class FeedApp extends StatelessWidget {
  const FeedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed App',
      home: const FeedPage(),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed'));
      if (response.statusCode == 200) {
        final fetchedPosts = jsonDecode(response.body);
        setState(() {
          posts = fetchedPosts.map((post) {
            post['isLiked'] = false;
            return post;
          }).toList();
        });
      } else {
        print('Error retrieving posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> likePost(int index) async {
    final post = posts[index];
    final postId = post['id'];
    final currentLikes = post['likes'];

    // Check if the post is already liked
    final isLiked = post['isLiked'] ?? false;
    final updatedLikes = isLiked ? currentLikes - 1 : currentLikes + 1;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3001/feed/$postId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'likes': updatedLikes,
        }),
      );
      if (response.statusCode == 200) {
        final updatedPost = jsonDecode(response.body);
        setState(() {
          posts[index] = updatedPost;
          posts[index]['isLiked'] = !isLiked;
        });
      } else {
        print('Error updating post: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final isLiked = post['isLiked'] ?? false;
          final likeColor = isLiked ? Colors.red : Colors.grey;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Image.network(
                  post['image'],
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => likePost(index),
                  child: Icon(
                    Icons.favorite,
                    color: likeColor,
                  ),
                ),
                Text(
                  'Likes: ${post['likes']}',
                  style: TextStyle(
                    color: likeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
