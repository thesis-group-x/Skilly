import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'api.dart';
import 'aproducts.dart';

class Review {
  final String comment;
  final int stars;

  Review({required this.comment, required this.stars});
}

class ProductItemScreen extends StatefulWidget {
  final Product product;

  const ProductItemScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductItemScreenState createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  User? user;
  List<Review> reviews = [];

  TextEditingController commentController = TextEditingController();
  int selectedStars = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchReviews();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/user/byid/${widget.product.userId}'));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        setState(() {
          user = User.fromJson(userData);
        });
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/Market/reviews/${widget.product.id}'));
      if (response.statusCode == 200) {
        final reviewsData = json.decode(response.body);

        List<Review> fetchedReviews = [];
        for (var reviewData in reviewsData) {
          fetchedReviews.add(Review(
            comment: reviewData['comment'],
            stars: reviewData['rating'],
          ));
        }

        setState(() {
          reviews = fetchedReviews;
        });
      } else {
        print('Failed to fetch reviews. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> postReview(String comment, int stars) async {
    try {
      final response = await http.post(
        Uri.parse('http://${localhost}:3001/Market/reviews'),
        body: json.encode({
          'userId': widget.product.userId,
          'postId': widget.product.id,
          'comment': comment,
          'rating': stars,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Review posted successfully, fetch updated reviews
        fetchReviews();
      } else {
        print('Failed to post review. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 29,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height /
                      3, //third of the picture
                  width: MediaQuery.of(context).size.width / 1,
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              buttonArrow(context),
              scroll(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget scroll() {
    return Padding(
      padding: const EdgeInsets.only(top: 180),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Buy Now'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Text(
                  'Seller',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                user != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user!.name}'),
                          Text('Email: erere'),
                          Text('City: ezdez'),
                          Text('Country: eéeé'),
                        ],
                      )
                    : Text('Loading seller information...'),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Text(
                  'Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                reviews.isNotEmpty
                    ? Column(
                        children: List.generate(
                          reviews.length,
                          (index) => steps(context, index, reviews[index]),
                        ),
                      )
                    : Text('No reviews available.'),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Text(
                  'Add Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                  ),
                ),
                const SizedBox(height: 10),
                Text('Rating'),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStars = index + 1;
                        });
                      },
                      child: Icon(
                        index < selectedStars ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final comment = commentController.text.trim();
                    if (comment.isNotEmpty && selectedStars > 0) {
                      postReview(comment, selectedStars);
                      commentController.clear();
                      setState(() {
                        selectedStars = 0;
                      });
                    }
                  },
                  child: Text('Submit Review'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget steps(BuildContext context, int index, Review review) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 5),
              Text(
                review.stars.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(review.comment),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String createdAt;
  final int level;
  final String imageProfile;

  User(
      {required this.name,
      required this.createdAt,
      required this.level,
      required this.imageProfile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        createdAt: json['createdAt'],
        level: json['level'],
        imageProfile: json['imageProfile']);
  }
}

const Color primary = Color(0xFF1FCC79);
const Color Secondary = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color form = Color(0xFFF4F5F7);
