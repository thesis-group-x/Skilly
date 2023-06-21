import 'package:client/market/components/pages/one1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import '../utils/api.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // States
  List<Productsi> products = [];
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
          List<Productsi> productList = [];
          for (var item in jsonData) {
            Productsi product = Productsi.fromJson(item);
            productList.add(product);
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
//the display

class HorizontalProductItem extends StatelessWidget {
  final Productsi product;

  HorizontalProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details1(product: product),
            ),
          );
        },
        child: Container(
          height: 230.0,
          width: 140.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Colors.grey[300],
                        height: 160.0,
                        width: 180.0,
                      );
                    } else {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: product.images[0],
                        height: 160.0,
                        width: 180.0,
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${product.price.toStringAsFixed(0)} Pts ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    // Flexible(
                    //   child: Text(
                    //     product.title,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15.0,
                    //     ),
                    //     maxLines: 2,
                    //     overflow: TextOverflow.ellipsis,
                    //     textAlign: TextAlign.right,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.skill.toUpperCase(),
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
  final List<String> images;
  final String title;
  final String description;
  final String skill;
  final double price;
  final int userId;

  Productsi({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.skill,
    required this.price,
    required this.userId,
  });

  factory Productsi.fromJson(Map<String, dynamic> json) {
    List<String> imageList =
        (json['image'] as List<dynamic>).map((e) => e.toString()).toList();
    return Productsi(
      id: json['id'],
      images: imageList,
      title: json['title'],
      description: json['description'],
      skill: json['skill'],
      price: json['price'].toDouble(),
      userId: json['userId'],
    );
  }
}
