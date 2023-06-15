import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/market/components/body.dart';
import '../bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: buildAppBar(),
        body: MyWidget(),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: 1,
          onTabSelected: (index) {},
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/menu.svg',
        ),
        onPressed: () {
          // Add functionality for the menu button
        },
      ),
    );
  }
}
