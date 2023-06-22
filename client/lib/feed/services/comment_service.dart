import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/comment.dart';
import '../models/user.dart' as local_user;

class CommentService {
  static Future<List<Comment>> getCommentsByPostId(int postId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/feedCom/$postId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final List<Comment> comments = [];

      for (var data in jsonData) {
        final comment = Comment.fromJson(data);
        final user = await getUserById(comment.userId);
        comment.setUser(user);
        comments.add(comment);
      }

      return comments;
    } else {
      throw Exception('Failed to retrieve comments');
    }
  }

  static Future<local_user.User> getUserById(int userId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/user/byid/$userId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return local_user.User.fromJson(jsonData);
    } else {
      throw Exception('Failed to retrieve user data');
    }
  }

  Future<Comment> createComment(int postId, String text) async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final uid = currentUser.uid;

    final commentData = {
      'postId': postId,
      'text': text,
      'userId': uid,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3001/feedCom/create'),
      body: jsonEncode(commentData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return Comment.fromJson(jsonData);
    } else {
      print('Server response: ${response.body}');
      throw Exception('Failed to create comment');
    }
  }
}
