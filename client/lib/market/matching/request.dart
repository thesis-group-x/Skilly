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
  List<dynamic> friendRequests = [];
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
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/match/friendships/get/${FirebaseAuth.instance.currentUser?.uid}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is List<dynamic>) {
          List<dynamic> updatedFriendRequests = [];
          for (dynamic request in data) {
            final userDataResponse = await http.get(Uri.parse(
                'http://${localhost}:3001/user/byid/${request['requestorId']}'));

            if (userDataResponse.statusCode == 200) {
              final userData = json.decode(userDataResponse.body);
              if (userData != null && userData is Map<String, dynamic>) {
                request['name'] = userData['name'];
                request['image'] = userData['profileImage'];
                request['budge'] = userData['budge'];
                updatedFriendRequests.add(request);
              }
            }
          }

          setState(() {
            friendRequests = updatedFriendRequests;
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
      final response = await http.put(Uri.parse(
          'http://${localhost}:3001/match/friendships/accept/$requestId'));

      if (response.statusCode == 200) {
      } else {
        print('Failed to accept friend request. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to accept friend request. Error: $error');
    }
  }

  Future<void> declineFriendRequest(int requestId) async {
    try {
      final response = await http.put(Uri.parse(
          'http://${localhost}:3001/match/friendships/decline/$requestId'));

      if (response.statusCode == 200) {
      } else {
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back icon to black
        ),
        elevation: 0, // Remove the elevation (shadow) of the app bar
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
                    Color statusColor;

                    // Set color based on status
                    switch (friendRequest['status']) {
                      case 'DECLINED':
                        statusColor = Colors.red;
                        break;
                      case 'ACCEPTED':
                        statusColor = Colors.green;
                        break;
                      default:
                        statusColor = Colors.yellow;
                        break;
                    }

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(friendRequest['image']),
                        ),
                        // title: Text('Level: ${friendRequest['level']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name : ${friendRequest['name']}'),
                            Text(
                              '${friendRequest['status']}',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              friendRequest['budge'],
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
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
                      ),
                    );
                  },
                ),
    );
  }
}
