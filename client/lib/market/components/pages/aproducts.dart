import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

import '../utils/api.dart';
import 'one.dart';
import 'one1.dart';

class Aproducts extends StatefulWidget {
  const Aproducts({Key? key}) : super(key: key);

  @override
  _AproductsState createState() => _AproductsState();
}

class _AproductsState extends State<Aproducts> {
  // States
  List<P> products = [];
  Map<int, List<Reviewi>> postReviews = {};
  Map<int, double> productAverageRatings = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://${localhost}:3001/Market/posts'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<P> productList = [];
          for (var item in jsonData) {
            P product = P.fromJson(item);
            productList.add(product);
            fetchReviews(product.id);
          }
          setState(() {
            products = productList;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Invalid API response';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch product data';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $error';
      });
    }
  }

  double calculateTotalRating(List<Reviewi> reviews) {
    double totalRating = 0.0;

    for (var review in reviews) {
      totalRating += review.rating;
    }
    return totalRating;
  }

  Future<void> fetchReviews(int id) async {
    try {
      final response = await http
          .get(Uri.parse('http://${localhost}:3001/Market/reviews/$id'));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data != null && data is List<dynamic>) {
          List<Reviewi> fetchedReviews =
              data.map((review) => Reviewi.fromJson(review)).toList();
          double averageRating = calculateAverageRating(fetchedReviews);
          setState(() {
            postReviews[id] = fetchedReviews;
            productAverageRatings[id] = averageRating;
          });
        } else {
          print('Invalid review data');
        }
      } else {
        print('Failed to fetch reviews. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch reviews. Error: $error');
    }
  }

  double calculateAverageRating(List<Reviewi> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }

    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating;
    }
    double averageRating = totalRating / reviews.length;
    return double.parse(averageRating.toStringAsFixed(1));
  }

  List<P> filterProductsByRating(double minRating) {
    return products
        .where((product) =>
            productAverageRatings[product.id] != null &&
            productAverageRatings[product.id]! >= minRating)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (errorMessage.isNotEmpty) {
      return Text(errorMessage);
    } else {
      List<P> filteredProducts = filterProductsByRating(3.0);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filteredProducts.reversed.map((product) {
            int totalReviews = postReviews.containsKey(product.id)
                ? postReviews[product.id]!.length
                : 0;
            return HorizontalProductItem(
              product: product,
              totalReviews: totalReviews,
              averageRating: productAverageRatings[product.id] ?? 0.0,
            );
          }).toList(),
        ),
      );
    }
  }
}

class HorizontalProductItem extends StatelessWidget {
  final P product;
  final int totalReviews;
  final double averageRating;

  HorizontalProductItem({
    required this.product,
    required this.totalReviews,
    required this.averageRating,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 20.0, bottom: 40),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(product: product),
            ),
          );
        },
        child: Container(
          height: 260.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 3.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 500)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.grey[300],
                            height: 200.0,
                            width: double.infinity,
                          );
                        } else {
                          return FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: product.image[0],
                            height: 200.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              averageRating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '${product.price.toStringAsFixed(0)} pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.blueGrey[300],
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const kDefaultPadding = 20.0;

class P {
  final int id;
  final List<String> image;
  final String title;
  final String description;
  final String skill;
  final double price;
  final int userId;

  P({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.skill,
    required this.price,
    required this.userId,
  });

  factory P.fromJson(Map<String, dynamic> json) {
    return P(
      id: json['id'],
      image: List<String>.from(json['image']),
      title: json['title'],
      description: json['description'],
      skill: json['skill'],
      price: json['price'].toDouble(),
      userId: json['userId'],
    );
  }
}

class Reviewi {
  final double rating;
  final String title;

  Reviewi({required this.rating, required this.title});

  factory Reviewi.fromJson(Map<String, dynamic> json) {
    return Reviewi(
      rating: json['rating'].toDouble(),
      title: json['comment'],
    );
  }
}
