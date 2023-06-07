import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/market/components/body.dart';
import '../bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: MyWidget(),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 1,
        onTabSelected: (index) {
          // Add your logic here based on the selected index
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/menu.svg', // Replace 'assetName' with your actual asset path
        ),
        onPressed: () {
          // Add functionality for the menu button
        },
      ),
    );
  }
}
