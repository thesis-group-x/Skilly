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
    Timer(Duration(seconds: 6), () {
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
          Text(
            'Popular',
            style: TextStyle(
                color: Color(0xFF284855),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          _isLoading
              ? Container(
                  height: size.height - kToolbarHeight,
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.network(
                        'https://i.pinimg.com/originals/f6/37/0b/f6370ba638aba31fc466f0a1d4fb59c2.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Products(key: UniqueKey()),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Popular',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 8, 26, 34),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
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
