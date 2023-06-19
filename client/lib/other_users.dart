import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottom_navigation.dart';

class UserProfileWidget extends StatefulWidget {
  final int userId;

  const UserProfileWidget({required this.userId});

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  String imagePath = '';
  String name = '';
  String level = '';

  List<dynamic> posts = [];
  List<dynamic> marketPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchUserPosts();
    fetchUserMarketPosts();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/other/${widget.userId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          imagePath = data['profileImage'];
          name = data['name'];
          level = data['level'];
        });
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/other/post/${widget.userId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          posts = data;
        });
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

  Future<void> fetchUserMarketPosts() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3001/other/marketpost/${widget.userId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          marketPosts = data;
        });
      } else {
        debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint('Error: $e', wrapWidth: 1024);
    }
  }

Widget buildProfileInfo() {
  return Scaffold(
        appBar: AppBar(
           backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context); // Pops the current context
        },
      ),
    ),
    body: SingleChildScrollView(
      child: Container(
         padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(imagePath),
                  ),
                  SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Posts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '${posts.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          Text(
                            'Level',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            level,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 79),
            Column(
              children: [
                Text(
                  'Posts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Container(
                        width: 300,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.network(
                              post['image'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Market Posts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: marketPosts.map<Widget>((marketPost) {
                        return Container(
                          width: 300,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                marketPost['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                marketPost['image'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Price: \$${marketPost['price']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: buildProfileInfo(),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTabSelected: (index) {
        },
      ),
    );
    
  }
}

// Usage example
class OtherProfile extends StatelessWidget {
  final int userId;

  const OtherProfile({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfileWidget(userId: userId),
    );
  }
}

void main() {
  runApp(OtherProfile(userId: 1));
}