// ignore_for_file: unnecessary_null_comparison, library_prefixes

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/feed/models/user.dart' as UserModel;

class UserService {
  static Future<UserModel.User> fetchUserById(int userId) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/user/byid/$userId'));

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final decodedData = json.decode(responseData);
        return UserModel.User.fromJson(decodedData);
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch user');
    }
  }


   static Future<UserModel.User> fetchUserByUid() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final uid = user.uid;
    final token = await user.getIdToken();

    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/user/byid/$uid'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final decodedData = json.decode(responseData);
        return UserModel.User.fromJson(decodedData);
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch user');
    }
  }

static Future<UserModel.User> fetchUserByFirebaseUid() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }

  final uid = user.uid;
  final response = await http.get(
    Uri.parse('http://10.0.2.2:3001/user/byuid/$uid'),
  );

  if (response.statusCode == 200) {
    final responseData = response.body;
    if (responseData != null) {
      final decodedData = json.decode(responseData);
      return UserModel.User.fromJson(decodedData);
    } else {
      throw Exception('Invalid API response');
    }
  } else {
    throw Exception('Failed to fetch user');
  }
}

}
