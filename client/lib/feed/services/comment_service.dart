import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment.dart';
import '../models/user.dart';

class CommentService {
  static Future<List<Comment>> getCommentsByPostId(int postId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/feedCom/$postId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to retrieve comments');
    }
  }

  static Future<Comment> createComment(int postId, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final commentData = {
      'postId': postId,
      'text': text,
      'userId': user.email,
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
