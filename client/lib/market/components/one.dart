import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'aproducts.dart';
import 'reviews.dart';

class Details extends StatefulWidget {
  final Product product;

  const Details({required this.product});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int finalRating = 0;

  @override
  void initState() {
    super.initState();
    fetchReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          buildSlider(),
          SizedBox(height: 20),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reviews(
                                    review: Review(
                                  postId: widget.product.id,
                                  userId: widget.product.userId,
                                  comment: '',
                                  rating: 0,
                                ))),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          '${finalRating}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.blueGrey[300],
                  ),
                  SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.product.skill,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.product.price} Points',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.airplanemode_active,
        ),
        onPressed: () {},
      ),
    );
  }

  buildSlider() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 250.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          widget.product.image,
          height: 250.0,
          width: 300 - 40.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void fetchReviews(int postId) async {
    final url = 'http://localhost:3001/Market/reviews/$postId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Review> reviews = List<Review>.from(
          data.map((review) => Review.fromJson(review)),
        );

        setState(() {
          finalRating = calculateFinalRating(reviews);
        });
      } else {
        print('Failed to fetch reviews. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch reviews. Error: $error');
    }
  }

  int calculateFinalRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0;
    }

    int totalStars = 0;
    for (var review in reviews) {
      totalStars += review.rating;
    }

    double averageRating = totalStars / reviews.length;
    return averageRating.floor();
  }
}

class Review {
  final String comment;
  final int rating;
  final int userId;
  final int postId;

  Review(
      {required this.comment,
      required this.rating,
      required this.postId,
      required this.userId});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      comment: json['comment'],
      rating: json['rating'],
      postId: json['postId'],
      userId: json['userId'],
    );
  }
}
