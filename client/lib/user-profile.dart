// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class UserProfilePage extends StatefulWidget {
//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   String imagePath = '';
//   String name = '';
//   String email = '';
//   int numberOfPosts = 0;
//   int numberOfMatches = 0;
//   String level = '';    
//   List<dynamic> feedposts = [];
//    List<dynamic> posts = [];

//   List<dynamic> reviews = [];
//   bool showAllPosts = false;
//   bool showAllReviews = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//     fetchPosts();
//     fetchReviews();
//     fetchUserFeedPosts();
//     fetchUserMarketPosts();
//   }

//   Future<void> fetchUserProfile() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2:3001/user/byid/2'));
//       final userData = json.decode(response.body);

//       setState(() {
//         imagePath = userData['profileImage'];
//         name = userData['name'];
//         email = userData['email'];
//         numberOfPosts = userData['posts'].length;
//         numberOfMatches = userData['memberships'].length;
//         level = userData['level'];
//       });
//     } catch (error) {
//       print('Error fetching user profile: $error');
//     }
//   }

//   Future<void> fetchPosts() async {
//     try {
//       final response = await http.get(Uri.parse('http://10.0.2.2:3001/feed'));
//       final postData = json.decode(response.body);

//       setState(() {
//         posts = postData['data'];
//       });
//     } catch (error) {
//       print('Error fetching posts: $error');
//     }
//   }

//   Future<void> fetchReviews() async {
//     try {
//       final response = await http.get(Uri.parse('http://10.0.2.2:3001/market'));
//       final marketData = json.decode(response.body);

//       setState(() {
//         reviews = marketData['data'];
//       });
//     } catch (error) {
//       print('Error fetching reviews: $error');
//     }
//   }

//   Future<void> fetchUserFeedPosts() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2:3001/user/2/feed/posts'));
//       final feedPostsData = json.decode(response.body);

//       setState(() {
//         feedposts = feedPostsData['data'];
//       });
//     } catch (error) {
//       print('Error fetching user feed posts: $error');
//     }
//   }

//   Future<void> fetchUserMarketPosts() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2:3001/user/2/market/posts'));
//       final marketPostsData = json.decode(response.body);

//       setState(() {
//         posts = marketPostsData['data'];
//       });
//     } catch (error) {
//       print('Error fetching user market posts: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         padding: EdgeInsets.all(16),
//         children: [
//           buildProfileInfo(),
//           SizedBox(height: 24),
//           buildPostsSection(),
//           SizedBox(height: 24),
//           buildReviewsSection(),
//         ],
//       ),
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     final icon = CupertinoIcons.moon_stars;

//     return AppBar(
//       leading: BackButton(),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: Icon(icon),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget buildProfileInfo() {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 64,
//           backgroundImage: NetworkImage(imagePath),
//         ),
//         SizedBox(height: 16),
//         Text(
//           name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           email,
//           style: TextStyle(
//             color: Colors.grey,
//             fontSize: 16,
//           ),
//         ),
//         SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             buildInfoItem('Posts', numberOfPosts.toString()),
//             SizedBox(width: 24),
//             buildInfoItem('Matches', numberOfMatches.toString()),
//             SizedBox(width: 24),
//             buildInfoItem('Level', level),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildInfoItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildPostsSection() {
//   final visiblePosts = showAllPosts ? posts :   posts.take(3).toList();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Posts',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       SizedBox(height: 8),
//       ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: visiblePosts.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(visiblePosts[index]['title']),
//           );
//         },
//       ),
//       buildShowMoreButton(feedposts.length > 3),
//       buildShowLessButton(showAllPosts),
//     ],
//   );
// }

// Widget buildReviewsSection() {
//   final visibleReviews = showAllReviews ? reviews : reviews.take(3).toList();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Reviews',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       SizedBox(height: 8),
//       ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: visibleReviews.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(visibleReviews[index]['title']),
//           );
//         },
//       ),
//       buildShowMoreButton(reviews.length > 3),
//       buildShowLessButton(showAllReviews),
//     ],
//   );
// }


//   Widget buildShowMoreButton(bool visible) {
//     return Visibility(
//       visible: visible,
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             if (showAllPosts) {
//               showAllReviews = true;
//             } else {
//               showAllPosts = true;
//             }
//           });
//         },
//         child: Text(
//           'Show More',
//           style: TextStyle(
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildShowLessButton(bool visible) {
//     return Visibility(
//       visible: visible,
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             if (showAllPosts) {
//               showAllReviews = false;
//             } else {
//               showAllPosts = false;
//             }
//           });
//         },
//         child: Text(
//           'Show Less',
//           style: TextStyle(
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'SKILLY',
//     home: UserProfilePage(),
//   ));
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final int userId;

  UserProfilePage({required this.userId});

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
    fetchUser();
    fetchFeedPosts();
    fetchMarketPosts();
    fetchReviews();
  }

  Future<void> fetchUser() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/user/byid/${widget.userId}'));
    if (response.statusCode == 200) {
      setState(() {
        user = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchFeedPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/user/${widget.userId}/feed/posts'));
    if (response.statusCode == 200) {
      setState(() {
        feedPosts = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchMarketPosts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/user/${widget.userId}/market/posts'));
    if (response.statusCode == 200) {
      setState(() {
        marketPosts = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchReviews() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/user/${widget.userId}/market/reviews'));
    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }

  int getTotalPosts() {
    return feedPosts.length + marketPosts.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user['profileImage'] ?? ''),
                radius: 64,
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
                  buildInfoItem('Matches', '0'), // Replace with the actual number of matches
                  SizedBox(width: 24),
                  buildInfoItem('Level', '1'), // Replace with the actual level
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
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: feedPosts.length + marketPosts.length,
          itemBuilder: (context, index) {
            if (index < feedPosts.length) {
              return buildFeedPostItem(feedPosts[index]);
            } else {
              final marketIndex = index - feedPosts.length;
              return buildMarketPostItem(marketPosts[marketIndex]);
            }
          },
        ),
      ],
    );
  }

  Widget buildFeedPostItem(dynamic post) {
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
          if (post['image'] != null)
          Image.network(
            post['image'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        SizedBox(height: 8),
          Text(
            post['title' ]?? '',
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
            'Posted on ${post['date']?? ''}',
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
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
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
            post['title']?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            post['description']?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Price: \$${post['price']?? ''}',
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
            return buildReviewItem(reviews[index]);
          },
        ),
      ],
    );
  }

  Widget buildReviewItem(dynamic review) {
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
            review['reviewer']?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            review['comment']?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Rating: ${review['rating']?? ''}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}




void main() {
  runApp(MaterialApp(
    title: 'SKILLY',
    home: UserProfilePage(userId: 2),
  ));
}


