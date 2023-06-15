// ignore_for_file: unnecessary_null_comparison

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed'));

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final List<dynamic> decodedData = json.decode(responseData);
        final List<Post> fetchedPosts = [];

        for (var postJson in decodedData) {
          final userResponse = await http.get(Uri.parse(
              'http://10.0.2.2:3001/user/byid/${postJson['userId']}'));
          final userData = json.decode(userResponse.body);

          postJson['user'] = userData;

          fetchedPosts.add(Post.fromJson(postJson));
        }

        return fetchedPosts;
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

 
  static Future<int> likePost(int postId) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.18:3001/feed/$postId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, bool>{'like': true}),
      );
      
      return response.statusCode;

    } catch (error) {
      throw Exception('Failed to like the post');
    }
  }

  static Future<int> unlikePost(int postId) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.18:3001/feed/$postId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, bool>{'like': false}),
      );
      
      return response.statusCode;
      
    } catch (error) {
      throw Exception('Failed to unlike the post');
    }
  }
static Future<List<Post>> getPostsBySkill(String skill) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed/skill/$skill')); 

  if (response.statusCode == 200) {
    final responseData = response.body;
    if (responseData != null) {
      final List<dynamic> decodedData = json.decode(responseData);
      final List<Post> fetchedPosts = [];

      for (var postJson in decodedData) {
        final userResponse = await http.get(Uri.parse(
            'http://10.0.2.2:3001/user/byid/${postJson['userId']}'));
        final userData = json.decode(userResponse.body);

        postJson['user'] = userData;

        fetchedPosts.add(Post.fromJson(postJson));
      }

      return fetchedPosts;
    } else {
      throw Exception('Invalid API response');
    }
  } else {
    throw Exception('Failed to fetch posts by skill');
  }
}

  static Future<Post> createPost(String image, String title, String skill, String desc, String userId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final postData = {
      'image': image,
      'title': title,
      'skill': skill,
      'desc': desc,
      'userId': user.uid,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3001/feed/post'),
      body: jsonEncode(postData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return Post.fromJson(jsonData);
    } else {
      throw Exception('Failed to create post');
    }
  }

   static Future<List<Post>> getPostsBySkillOrTitle(String searchQuery) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed?search=$searchQuery'));

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final List<dynamic> decodedData = json.decode(responseData);
        final List<Post> fetchedPosts = [];

        for (var postJson in decodedData) {
          final userResponse = await http.get(Uri.parse(
              'http://10.0.2.2:3001/user/byid/${postJson['userId']}'));
          final userData = json.decode(userResponse.body);

          postJson['user'] = userData;

          fetchedPosts.add(Post.fromJson(postJson));
        }

        return fetchedPosts;
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch posts by skill or title');
    }
  }

static Future<List<Post>> getPostsByUserSkillsAndHobbies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final idToken = await user.getIdToken(); 

    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/feed'),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final List<dynamic> decodedData = json.decode(responseData);
        final List<Post> fetchedPosts = [];

        // Fetch user's skills and hobbies
        final userResponse = await http.get(
          Uri.parse('http://10.0.2.2:3001/user/byid/${user.uid}'),
          headers: {'Authorization': 'Bearer $idToken'},
        );
        final userData = json.decode(userResponse.body);
        final List<String> userSkills = List<String>.from(userData['skills']);
        final List<String> userHobbies = List<String>.from(userData['hobbies']);

        for (var postJson in decodedData) {
          final postSkills = List<String>.from(postJson['skills']);
          final postHobbies = List<String>.from(postJson['hobbies']);

          // Check if any of the post's skills or hobbies match the user's skills or hobbies
          if (postSkills.any((skill) => userSkills.contains(skill)) ||
              postHobbies.any((hobby) => userHobbies.contains(hobby))) {
            final userResponse = await http.get(Uri.parse(
                'http://10.0.2.2:3001/user/byid/${postJson['userId']}'));
            final userData = json.decode(userResponse.body);

            postJson['user'] = userData;

            fetchedPosts.add(Post.fromJson(postJson));
          }
        }

        return fetchedPosts;
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

}


