import 'package:client/market/components/screens/reviews1.dart';
import 'package:client/other_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/api.dart';
import 'aproducts.dart';
import 'succ-creation.dart';

class Details extends StatefulWidget {
  final P product;

  const Details({required this.product});

  @override
  _Details11State createState() => _Details11State();
}

class _Details11State extends State<Details> {
  int finalRating = 0;
  late User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews(widget.product.id);
    fetchUserDetails(widget.product.userId);
  }

  void fetchUserDetails(int userId) async {
    final url = 'http://${localhost}:3001/user/byid/$userId';

    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User(
          id: data['id'],
          name: data['name'],
          image: data['profileImage'],
        );

        setState(() {
          this.user = user;
          isLoading = false;
        });
      } else {
        print('Failed to fetch user details. Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Failed to fetch user details. Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  navigateToUserDetails(id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileWidget(
          id: id,
          userId: id,
        ),
      ),
    );
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
            icon: Icon(Icons.notifications_active),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
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
                                builder: (context) => Reviews1(
                                  review: Div1(
                                    comment: '',
                                    rating: finalRating,
                                    postId: widget.product.id,
                                    userId: widget.product.userId,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: index < finalRating
                                    ? Colors.yellow
                                    : Colors.grey,
                                size: 27,
                              ),
                            ),
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
                        '${widget.product.price.toStringAsFixed(0)} Points',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: navigateToUserDetails(user.id),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(user.image),
                          ),
                        ],
                      ),
                    ),
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
                    ElevatedButton(
                      onPressed: () {
                        _buyProduct();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(
                                255, 0, 0, 0)), // Set the background color
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(16)), // Set the padding
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(fontSize: 18)), // Set the text style
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Set the border radius
                          ),
                        ),
                      ),
                      child: Text('Buy'),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Rate Product'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Select your rating:'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => IconButton(
                            onPressed: () {
                              setState(() {
                                finalRating = index + 1;
                              });
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.star,
                              color: index < finalRating
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.star),
      ),
    );
  }

  void _buyProduct() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final url = 'http://${localhost}:3001/Market/posts/buy';
    final body = {
      "postId": widget.product.id,
      "buyerId": uid,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Insufficient Funds'),
              content:
                  Text('Your funds are not sufficient to buy this product.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to buy product. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to buy product. Error: $error');
    }
  }

  buildSlider() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 350.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.image.length,
        itemBuilder: (BuildContext context, int index) {
          final imageUrl = widget.product.image[index];
          return Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                height: 400.0,
                width: 410 - 40,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  void fetchReviews(int postId) async {
    final url = 'http://${localhost}:3001/Market/reviews/$postId';
    print(postId);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Reviewi> reviews = List<Reviewi>.from(
          data.map((review) => Reviewi.fromJson(review)),
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

  int calculateFinalRating(List<Reviewi> reviews) {
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

class Reviewi {
  late final String comment;
  late final int rating;
  final int userId;
  final int postId;

  Reviewi(
      {required this.comment,
      required this.rating,
      required this.postId,
      required this.userId});

  factory Reviewi.fromJson(Map<String, dynamic> json) {
    return Reviewi(
      comment: json['comment'],
      rating: json['rating'],
      postId: json['postId'],
      userId: json['userId'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String image;

  User({required this.id, required this.name, required this.image});
}
