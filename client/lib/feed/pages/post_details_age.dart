// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';

class PostDetailsPage extends StatefulWidget {
  final Post post;

  const PostDetailsPage({required this.post});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final postComments =
          await CommentService.getCommentsByPostId(widget.post.id);
      setState(() {
        comments = postComments;
      });
    } catch (error) {
      print('Error retrieving comments: $error');
    }
  }

Future<void> createComment() async {
  final String commentText = commentController.text.trim();
  if (commentText.isNotEmpty) {
    try {
      final Comment newComment =
          await CommentService.createComment(widget.post.id, commentText);
      setState(() {
        comments.add(newComment);
      });
      commentController.clear();
    } catch (error) {
      print('Error creating comment: $error');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Comments:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment.text),
                    subtitle: Text('User: ${comment.userId}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Add a comment',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: createComment,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
