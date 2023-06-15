import 'package:client/market/components/one1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // States
  List<Map<String, dynamic>> products = [];
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
          List<Map<String, dynamic>> productList = [];
          for (var item in jsonData) {
            String image = item['image'];
            String title = item['title'];
            int price = item['price'];
            String skill = item['skill'];
            Map<String, dynamic> productData = {
              'image': image,
              'title': title,
              'price': price,
              'skill': skill,
            };
            productList.add(productData);
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (errorMessage.isNotEmpty) {
      return Text(errorMessage);
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: products.reversed.map((product) {
            return HorizontalProductItem(product: product);
          }).toList(),
        ),
      );
    }
  }
}

class HorizontalProductItem extends StatelessWidget {
  final Map<String, dynamic> product;

  HorizontalProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 10),
      child: InkWell(
        child: Container(
          height: 230.0,
          width: 140.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    Productsi productObject = Productsi(
                      id: product['id'] ?? 8,
                      image: product['image'] ?? '',
                      title: product['title'] ?? '',
                      description: product['description'] ?? '',
                      skill: product['skill'] ?? '',
                      price: product['price'] != null
                          ? product['price'].toDouble()
                          : 0.0,
                      userId: product['userId'] ?? 8,
                    );
                    print(productObject);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details1(product: productObject),
                      ),
                    );
                  },
                  child: Image.network(
                    product["image"],
                    height: 160.0,
                    width: 180.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "\$${product["price"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Flexible(
                      child: Text(
                        product["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  product["skill"].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.blueGrey[300],
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Productsi {
  final int id;
  final String image;
  final String title;
  final String description;
  final String skill;
  final double price;
  final int userId;

  Productsi(
      {required this.id,
      required this.image,
      required this.title,
      required this.description,
      required this.skill,
      required this.price,
      required this.userId});

  factory Productsi.fromJson(Map<String, dynamic> json) {
    return Productsi(
        id: json['id'],
        image: json['image'],
        title: json['title'],
        description: json['description'],
        skill: json['skill'],
        price: json['price'].toDouble(),
        userId: json['userId']);
  }
}
