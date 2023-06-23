import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import 'onesea.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<P1> _searchResults = [];
  Map<int, List<Reviewi>> postReviews = {}; // Map to store post reviews
  Map<int, double> productAverageRatings = {}; // Map to store average ratings
  bool isLoading = false;
  String errorMessage = '';

  Future<List<P1>> _performSearch(String query) async {
    if (query.isNotEmpty) {
      try {
        final response =
            await http.get(Uri.parse('http://${localhost}:3001/Market/posts'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          List<P1> allPosts = data.map((item) => P1.fromJson(item)).toList();
          List<P1> results = allPosts.where((post) {
            return post.skill.toLowerCase().contains(query.toLowerCase()) ||
                post.title.toLowerCase().contains(query.toLowerCase());
          }).toList();

          for (var post in results) {
            await fetchReviews(post.id);
          }

          return results;
        } else {
          throw Exception('Failed to fetch posts');
        }
      } catch (e) {
        // Handle error if the search fails
        print('Search failed: $e');
        return [];
      }
    }
    return [];
  }

  void navigateToPost(P1 post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Details3(product: post)),
    );
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

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

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      // If search is performed and no results are found
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No results found.'),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/search.json',
              width: 200,
              height: 200,
            ),
          ],
        ),
      );
    } else {
      // If there are search results or no search is performed
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          P1 post = _searchResults[index];
          double averageRating = productAverageRatings[post.id] ?? 0.0;
          return GestureDetector(
            onTap: () {
              navigateToPost(post);
              // print(postReviews);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(post.image[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          post.skill,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Rating: ${averageRating.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            _performSearch(query).then((results) {
              setState(() {
                _searchResults = results;
              });
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black87,
            ),
            hintText: "Search",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.black87,
            ),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults = [];
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }
}

class P1 {
  final int id;
  final String title;
  final double price;
  final List<String> image;
  final String description;
  final String skill;
  final int userId;

  P1({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.skill,
    required this.userId,
  });

  factory P1.fromJson(Map<String, dynamic> json) {
    return P1(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: List<String>.from(json['image']),
      description: json['description'],
      skill: json['skill'],
      userId: json['userId'],
    );
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
