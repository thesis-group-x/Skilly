import 'package:client/market/components/Button.dart';
import 'package:client/market/components/Search.dart';
import 'package:client/market/components/aproducts.dart';
import 'package:client/market/components/products.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //tkhali device sghar ynajmou yraw
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        HeaderWithSearchBox(size: size),
        SkillsList(),
        Products(key: UniqueKey()),
        // TitleWithMoreBtn(title: "Last Gigs", press: () {}),
        Aproducts(key: UniqueKey()),
      ]),
    );
  }
}
