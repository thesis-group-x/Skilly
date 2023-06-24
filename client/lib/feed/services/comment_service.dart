import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../market/components/utils/api.dart';
import '../models/comment.dart';
import '../models/user.dart' as local_user;

class CommentService {
  static Future<List<Comment>> getCommentsByPostId(int postId) async {
    final response =
        await http.get(Uri.parse('http://${localhost}:3001/feedCom/$postId'));

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
        await http.get(Uri.parse('http://${localhost}:3001/user/byid/$userId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return local_user.User.fromJson(jsonData);
    } else {
      throw Exception('Failed to retrieve user data');
    }
  }

  static Future<void> createComment(String text, int postId) async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userId = user.uid;
    final token = await user.getIdToken();

    final response = await http.post(
      Uri.parse('http://${localhost}:3001/feedCom/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Include the user token in the headers
      },
      body: jsonEncode({
        'text': text,
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final comment = Comment.fromJson(jsonData['comment']);
      final updatedUser = local_user.User.fromJson(jsonData['user']);
      comment.setUser(updatedUser);
      // Handle the created comment and updated user as required
    } else {
      throw Exception('Failed to create comment');
    }
  }
}
