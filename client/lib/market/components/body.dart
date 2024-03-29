import 'dart:async';
import 'package:client/market/components/pages/aproducts.dart';
// import 'package:client/market/components/screens/Button.dart';
import 'package:client/market/components/screens/Search.dart';
import 'package:client/market/components/pages/products.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //tkhali device sghar ynajmou yraw
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          //for the text
          Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular',
                style: TextStyle(
                  color: Color(0xFF284855),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Column(
            children: [
              Products(key: UniqueKey()),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Best Reviews',
                              style: TextStyle(
                                color: Color(0xFF284855),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ])),
              Aproducts(key: UniqueKey()),
            ],
          ),
        ],
      ),
    );
  }
}
