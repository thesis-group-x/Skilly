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
  List<Review> reviews = [];
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
                return ListTile(
                  title: Text(reviews[index].comment),
                  subtitle: Row(
                    children: [
                      Text('Rating:'),
                      SizedBox(width: 5),
                      Row(
                        children: List.generate(
                          reviews[index].rating,
                          (index) => Icon(Icons.star, color: Colors.yellow),
                        ),
                      ),
                    ],
                  ),
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
                    Text('Rating:'),
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
                  onPressed: () {
                    // Post the review
                    postReview(widget.review.comment, widget.review.rating);
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
        List<Review> fetchedReviews =
            List<Review>.from(data.map((review) => Review.fromJson(review)));
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

  Future<void> postReview(String comment, int rating) async {
    try {
      final response = await http.post(
        Uri.parse('http://${localhost}:3001/Market/reviews'),
        body: json.encode({
          'userId': widget.review.userId,
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
