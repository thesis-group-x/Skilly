import 'package:flutter/material.dart';
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
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.white, // Set the app bar background color to white
          iconTheme:
              IconThemeData(color: Colors.black), // Set the icon color to black
          elevation: 0, // Remove the app bar elevation
        ),
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
      leading: IconButton(
        icon: Icon(
          Icons.menu, // Use the Icons.menu instead of SvgPicture.asset
        ),
        onPressed: () {
          // Add functionality for the menu button
        },
      ),
    );
  }
}
