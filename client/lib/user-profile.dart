import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'bottom_navigation.dart';
import 'edit_profile.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic> user = {};
  List<dynamic> feedPosts = [];
  List<dynamic> marketPosts = [];
  List<dynamic> reviews = [];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      fetchUser();
      fetchFeedPosts();
      fetchMarketPosts();
      fetchReviews();
    } else {
      // Handle user not authenticated
    }
  }

  Future<void> fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Current User: $currentUser');
    if (currentUser != null) {
      final uid = currentUser.uid;
      print('Fetching user: $uid');
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3001/user/uid/$uid'));
      if (response.statusCode == 200) {
        setState(() {
          user = json.decode(response.body);
        });
        print('User fetched successfully: $user');
      } else {
        print('Failed to fetch user. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Undefined user');
    }
  }

  Future<void> fetchFeedPosts() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/user/uid/$uid/feed/posts'));
      if (response.statusCode == 200) {
        setState(() {
          feedPosts = json.decode(response.body);
        });
      } else {
        // Handle error
      }
    }
  }

  Future<void> fetchMarketPosts() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/user/uid/$uid/market/posts'));
      if (response.statusCode == 200) {
        setState(() {
          marketPosts = json.decode(response.body);
        });
      } else {
        // Handle error
      }
    }
  }

  Future<void> fetchReviews() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3001/user/$uid/$uid/market/reviews'));
      if (response.statusCode == 200) {
        setState(() {
          reviews = json.decode(response.body);
        });
      } else {
        // Handle error
      }
    }
  }

  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      _updateProfileImage();
    }
  }

  Future<void> _updateProfileImage() async {
    if (_image == null) {
      return;
    }

    final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dwtho2kip/upload';
    final cloudinaryPreset = 'kusldcry';

    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image!.path),
      'upload_preset': cloudinaryPreset,
    });

    final user = FirebaseAuth.instance.currentUser;
    print('User: $user');
    if (user != null) {
      final uid = user.uid;
      print('User ID: $uid');

      try {
        final cloudinaryResponse =
            await dio.post(cloudinaryUrl, data: formData);
        final imageUrl = cloudinaryResponse.data['secure_url'];

        // Prepare the request body
        final body = {
          'profileImage': imageUrl,
        };

        final updateResponse = await http.put(
          Uri.parse('http://10.0.2.2:3001/user/upd/$uid'),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'},
        );

        // Handle the response here, e.g., show a success message
      } catch (error) {
        // Handle the error here
      }
    }
  }

  int getTotalPosts() {
    return feedPosts.length + marketPosts.length;
  }

  void updateUserProfile(Map<String, dynamic> updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.black,
            onPressed: () async {
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    onProfileUpdated: updateUserProfile,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _getImage(ImageSource.gallery),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user['profileImage'] ?? ''),
                      radius: 64,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Color(0xFF284855),
                      ),
                      child: Center(
                        child: IconButton(
                          iconSize: 16,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () => _getImage(ImageSource.gallery),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                user['name'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                user['email'] ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildInfoItem('Posts', getTotalPosts().toString()),
                  SizedBox(width: 24),
                  buildInfoItem('Matches', '0'),
                  SizedBox(width: 24),
                  buildInfoItem('Level', '1'),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          buildPostsSection(),
          SizedBox(height: 24),
          buildReviewsSection(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3,
        onTabSelected: (index) {
          // Add your logic here based on the selected index
        },
      ),
    );
  }

  Widget buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget buildPostsSection() {
    return Column(
      children: [
        Text(
          'Feed Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              feedPosts.length,
              (index) => buildFeedPostItem(feedPosts[index]),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Market Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              marketPosts.length,
              (index) => buildMarketPostItem(marketPosts[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFeedPostItem(dynamic post) {
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
          if (post['image'] != null)
            Image.network(
              post['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          SizedBox(height: 8),
          Text(
            post['title'] ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            post['content'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Posted on ${post['createdAt'] ?? ''}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMarketPostItem(dynamic post) {
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
          if (post['image'] != null)
            Image.network(
              post['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          SizedBox(height: 8),
          Text(
            post['title'] ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            post['skill'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            post['description'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Price: \$${post['price'] ?? ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Posted on ${post['createdAt'] ?? ''}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewsSection() {
    return Column(
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating: ${review['rating'] ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    review['comment'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posted by ${review['postedBy'] ?? ''}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
