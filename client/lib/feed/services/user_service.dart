// ignore_for_file: unnecessary_null_comparison

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserService {
  static Future<User> fetchUserById(int userId) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/user/byid/$userId'));

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData != null) {
        final decodedData = json.decode(responseData);
        return User.fromJson(decodedData);
      } else {
        throw Exception('Invalid API response');
      }
    } else {
      throw Exception('Failed to fetch user');
    }
  }
}
