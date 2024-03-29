import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/one.dart';
import '../utils/api.dart';

class Reviews1 extends StatefulWidget {
  final Div1 review;

  Reviews1({required this.review});

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews1> {
  List<Reviewi> reviews = [];
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return FutureBuilder<User>(
                  future: fetchUser(review.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Failed to load user data');
                    }
                    final user = snapshot.data;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user?.image ?? ''),
                      ),
                      title: Text(user?.name ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Rating:'),
                              SizedBox(width: 5),
                              Row(
                                children: List.generate(
                                  review.rating,
                                  (index) =>
                                      Icon(Icons.star, color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                          Text(review.comment),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a review',
                    ),
                    onChanged: (value) {
                      widget.review.comment = value;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    // Text('Rating:'),
                    SizedBox(width: 5),
                    Row(
                      children: List.generate(
                        selectedRating,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                            widget.review.rating = selectedRating;
                          },
                          child: Icon(
                            Icons.star,
                            color: index < selectedRating
                                ? Colors.yellow
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Get the currently logged-in user's ID
                    final user1 = await fetchUser1();
                    if (user1 == null) {
                      return;
                    }

                    // Post the review using the user's ID
                    postReview(
                        widget.review.comment, widget.review.rating, user1.id);
                  },
                  child: Text('Post Review'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/Market/reviews/${widget.review.postId}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Reviewi> fetchedReviews =
            List<Reviewi>.from(data.map((review) => Reviewi.fromJson(review)));
        setState(() {
          reviews = fetchedReviews;
        });
      } else {
        print('Failed to fetch reviews. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch reviews. Error: $error');
    }
  }

  Future<void> postReview(String comment, int rating, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://${localhost}:3001/Market/reviews'),
        body: json.encode({
          'userId': userId,
          'postId': widget.review.postId,
          'comment': comment,
          'rating': rating,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        fetchReviews();

        widget.review.comment = '';
        widget.review.rating = 0;
      } else {
        print('Failed to post review. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to post review. Error: $error');
    }
  }
}

class Div1 {
  final int userId;
  final int postId;
  String comment;
  int rating;

  Div1({
    required this.userId,
    required this.postId,
    required this.comment,
    required this.rating,
  });

  factory Div1.fromJson(Map<String, dynamic> json) {
    return Div1(
      userId: json['userId'],
      postId: json['postId'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }
}

class User {
  final String name;
  final String image;

  User({
    required this.name,
    required this.image,
  });
}

class User1 {
  final int id;
  final String name;
  final String image;

  User1({
    required this.id,
    required this.name,
    required this.image,
  });
}

Future<User1> fetchUser1() async {
  try {
    final response = await http.get(Uri.parse(
        'http://${localhost}:3001/user/uid/${FirebaseAuth.instance.currentUser?.uid}'));
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final user1 = User1(
        id: userData['id'],
        name: userData['name'],
        image: userData['profileImage'],
      );
      return user1;
    } else {
      throw Exception('Failed to fetch user data');
    }
  } catch (error) {
    throw Exception('Failed to fetch user data: $error');
  }
}

Future<User> fetchUser(int userId) async {
  try {
    final response =
        await http.get(Uri.parse('http://${localhost}:3001/user/byid/$userId'));
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final user = User(
        name: userData['name'],
        image: userData['profileImage'],
      );
      return user;
    } else {
      throw Exception('Failed to fetch user data');
    }
  } catch (error) {
    throw Exception('Failed to fetch user data: $error');
  }
}
