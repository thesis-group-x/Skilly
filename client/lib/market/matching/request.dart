import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/utils/api.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({Key? key}) : super(key: key);

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<dynamic> friendRequests = []; // List to store friend requests
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
  }

  Future<void> fetchFriendRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace the URL with your API endpoint that retrieves friend requests for the receiver
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/match/friendships/get/${FirebaseAuth.instance.currentUser?.uid}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is List<dynamic>) {
          setState(() {
            friendRequests = data;
            isLoading = false;
          });
        } else {
          setState(() {
            friendRequests = [];
            isLoading = false;
            errorMessage = 'Invalid friend request data';
          });
        }
      } else {
        setState(() {
          friendRequests = [];
          isLoading = false;
          errorMessage =
              'Failed to fetch friend requests. Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        friendRequests = [];
        isLoading = false;
        errorMessage = 'Failed to fetch friend requests. Error: $error';
      });
    }
  }

  Future<void> acceptFriendRequest(int requestId) async {
    try {
      // Replace the URL with your API endpoint to accept the friend request
      final response = await http.put(Uri.parse(
          'http://${localhost}:3001/match/friendships/accept/$requestId'));

      if (response.statusCode == 200) {
        // Friend request accepted successfully
        // You can perform any additional actions or updates here
      } else {
        // Failed to accept friend request
        print('Failed to accept friend request. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to accept friend request. Error: $error');
    }
  }

  Future<void> declineFriendRequest(int requestId) async {
    try {
      // Replace the URL with your API endpoint to decline the friend request
      final response = await http.put(Uri.parse(
          'http://${localhost}:3001/match/friendships/decline/$requestId'));

      if (response.statusCode == 200) {
        // Friend request declined successfully
        // You can perform any additional actions or updates here
      } else {
        // Failed to decline friend request
        print(
            'Failed to decline friend request. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to decline friend request. Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage),
                )
              : ListView.builder(
                  itemCount: friendRequests.length,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic friendRequest = friendRequests[index];
                    // Customize the UI based on the friend request data
                    return ListTile(
                      title: Text('Friend Request ID: ${friendRequest['id']}'),
                      subtitle: Text('Status: ${friendRequest['status']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Accept friend request logic
                              acceptFriendRequest(friendRequest['id']);
                            },
                            child: Text('Accept'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Decline friend request logic
                              declineFriendRequest(friendRequest['id']);
                            },
                            child: Text('Decline'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
