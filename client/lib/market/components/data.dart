import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api.dart';

class PostM {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String skill;
  final int userId;

  PostM({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.skill,
    required this.userId,
  });

  factory PostM.fromJson(Map<String, dynamic> json) {
    return PostM(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
      skill: json['skill'],
      userId: json['userId'],
    );
  }
}

Future<List<PostM>> fetchPosts() async {
  final response =
      await http.get(Uri.parse('http://${localhost}:3001/Market/posts'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => PostM.fromJson(item)).toList();
  } else {
    throw Exception('Failed to fetch posts');
  }
}
