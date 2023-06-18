import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import 'one.dart';

class Aproducts extends StatefulWidget {
  const Aproducts({
    required Key key,
  }) : super(key: key);

  @override
  _AproductsState createState() => _AproductsState();
}

class _AproductsState extends State<Aproducts> {
  List<P> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Getting data of the post
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://${localhost}:3001/Market/posts'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products = data.map((item) => P.fromJson(item)).toList();
      });
    } else {
      print('Failed to fetch data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Scroll horizontally
      child: Row(
        children: products.map((product) {
          return FeaturePlantCard(
            image: product.image[0], // Display the first image
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(product: product),
                ),
              );
            },
            key: UniqueKey(),
            title: product.title,
            skill: product.skill,
            price: product.price,
          );
        }).toList(),
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    required Key key,
    required this.image,
    required this.press,
    required this.title,
    required this.skill,
    required this.price,
  }) : super(key: key);

  final VoidCallback press;
  final String image;
  final String title;
  final String skill;
  final double price;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image), // Display the first image
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Skill: $skill',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

const kPrimaryColor = Colors.blue;
