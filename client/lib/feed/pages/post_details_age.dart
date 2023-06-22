import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      final Comment newComment = await CommentService().createComment(widget.post.id, commentText);
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
        title: Text(
          widget.post.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF284855),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.post.user.profileImage),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.post.user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.desc,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.9, // Adjust the value as needed
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.post.image),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
  itemCount: comments.length,
  separatorBuilder: (context, index) => Divider(
    color: const Color.fromARGB(255, 211, 211, 211),
    thickness: 1.0,
  ),
  itemBuilder: (context, index) {
    final comment = comments[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.user!.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          title: Text(comment.text),
          subtitle: Text('${comment.userId}'),
        ),
      ],
    );
  },
),

                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            labelText: 'Add a comment',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF284855),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.paperPlane,
                              color: Colors.white,
                            ),
                            onPressed: createComment,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
