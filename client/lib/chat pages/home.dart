import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'messages.dart';
import '../bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF284855),
        scaffoldBackgroundColor: Color.fromARGB(255, 243, 242, 236),
        fontFamily: 'Roboto',
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<String> users = [];
  List<String> filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers().then((fetchedUsers) {
      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers;
      });
    }).catchError((error) {
      print('Error fetching users: $error');
    });
  }

  Future<List<String>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/user/getuser'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final currentUser = FirebaseAuth.instance.currentUser?.displayName;
      return data
          .map((user) => user['name'] as String)
          .where((user) => user != currentUser)
          .toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  void filterUsers(String query) {
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((user) => user.toLowerCase().contains(lowercaseQuery))
          .toList();
      searchQuery = query;
    });
  }

  void navigateToChatPage(String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMessagesPage(userName: userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 12.0,
        title: Row(
          children: [
            SizedBox(width: 20.0),
            Text(
              'Messages',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  filterUsers(value);
                },
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    FontAwesomeIcons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              searchQuery = '';
                              filterUsers('');
                            });
                          },
                        ),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          user[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'Last active: 1 hour ago',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        navigateToChatPage(user);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(FontAwesomeIcons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 2,
        onTabSelected: (index) {
          // Add your logic here based on the selected index
        },
      ),
    );
  }
}
