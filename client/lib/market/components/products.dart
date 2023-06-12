import 'package:client/market/components/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products extends StatefulWidget {
  const Products({required Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  //states
  List<ProductData> products = [];
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
        final jsonData = json.decode(response.body); //data from the response
        if (jsonData is List) {
          List<ProductData> productList = []; //refile the array
          for (var item in jsonData) {
            String image = item['image'];
            String title = item['title'];
            int price = item['price'];
            String skill = item['skill'];
            ProductData productData = ProductData(
              image: image,
              title: title,
              price: price,
              skill: skill,
            );
            productList.add(productData); //refile the array with data
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
          children: products.map((product) {
            //here we return the data from the array and map throught it
            return RecomendPlantCard(
              key: UniqueKey(),
              image: product.image,
              title: product.title,
              skill: product.skill,
              price: product.price,
              press: () {},
            );
          }).toList(),
        ),
      );
    }
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    required Key key,
    required this.image,
    required this.title,
    required this.skill,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title, skill;
  final int price;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 1.4,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.network(image),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$title\n".toUpperCase(),
                          style: Theme.of(context).textTheme.button?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextSpan(
                          text: "$skill".toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductData {
  final String image;
  final String title;
  final String skill;
  final int price;

  ProductData({
    required this.image,
    required this.title,
    required this.skill,
    required this.price,
  });
}

const kPrimaryColor = Colors.blue; // Replace with your desired primary color
const kDefaultPadding = 20.0; // Replace with your desired default padding value
