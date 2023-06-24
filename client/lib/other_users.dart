import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'market/components/utils/api.dart';

class UserProfileWidget extends StatefulWidget {
  final int userId;

  const UserProfileWidget({required this.userId, required id});

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  Map<String, dynamic> userData = {};
  int id = 0;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchUser1();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://$localhost:3001/user/byid/${widget.userId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data;
        });
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

  Future<void> fetchUser1() async {
    try {
      final response = await http.get(Uri.parse(
          'http://$localhost:3001/user/uid/${FirebaseAuth.instance.currentUser?.uid}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          id = data['id'];
        });
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

  Future<void> createFriendship() async {
    final requestorId = id;
    final respondentId = widget.userId;

    try {
      final response = await http.post(
        Uri.parse('http://$localhost:3001/match/friendships'),
        body: jsonEncode({
          'requestorId': requestorId,
          'respondentId': respondentId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Friendship created successfully
        // You can handle the response or perform any necessary actions
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userData['profileImage'] ?? ''),
              ),
              SizedBox(height: 20),
              Text(
                userData['name'] ?? '',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IndicatorWidget(
                    icon: Icons.email,
                    text: userData['email'] ?? '',
                  ),
                  SizedBox(width: 10),
                  IndicatorWidget(
                    icon: Icons.phone,
                    text: userData['phoneNumber'].toString() ?? '',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Skills:',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userData['skills']?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final skill = userData['skills'][index];
                  return Text(
                    '- $skill',
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              BadgeLevelWidget(
                badge: userData['budge'] ?? '',
                level: userData['level'] ?? 0,
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: createFriendship,
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IndicatorWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const IndicatorWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class BadgeLevelWidget extends StatelessWidget {
  final String badge;
  final int level;

  const BadgeLevelWidget({required this.badge, required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Level: ',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          level.toString(),
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 20),
        Image.asset(
          badge,
          width: 30,
          height: 30,
        ),
      ],
    );
  }
}
