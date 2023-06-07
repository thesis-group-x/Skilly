import 'package:flutter/material.dart';

class Aproducts extends StatelessWidget {
  const Aproducts({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          FeaturePlantCard(
            image: "assets/images/feed.png",
            press: () {},
            key: UniqueKey(),
          ),
          FeaturePlantCard(
            image: "assets/images/feed.png",
            press: () {},
            key: UniqueKey(),
          ),
        ],
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    required Key key,
    required this.image,
    required this.press, // Updated: Made the 'press' parameter required
  }) : super(key: key);
  final String image;
  final VoidCallback
      press; // Updated: Changed the function type to VoidCallback

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
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

const kPrimaryColor = Colors.blue; // Replace with your desired primary color
const kDefaultPadding = 20.0; // Replace with your desired default padding value
