import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductItemScreen extends StatefulWidget {
  final int productId;

  const ProductItemScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ProductItemScreenState createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  late Future<Product> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
  }

  Future<Product> fetchProduct() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.169:3001/Market/post/${widget.productId}'));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Product.fromJson(data[0]);
    } else {
      throw Exception('Failed to fetch product data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Product'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Product'),
            ),
            body: Center(
              child: Text('Failed to fetch product data'),
            ),
          );
        } else {
          final product = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Product'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(product.image),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: primary,
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              product.title,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    product.skill,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Skill",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: SecondaryText),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    product.description,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: SecondaryText),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 1 / 1.3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class Product {
  final String title;
  final double price;
  final String image;
  final String description;
  final String skill;
  final int userId;

  Product({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.skill,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
      skill: json['skill'],
      userId: json['userId'],
    );
  }
}

const Color primary = Color(0xFF1FCC79);
const Color Secondary = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color form = Color(0xFFF4F5F7);
