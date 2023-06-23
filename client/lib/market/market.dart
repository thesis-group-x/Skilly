import 'package:flutter/material.dart';
import 'package:client/market/components/body.dart';
import '../bottom_navigation.dart';
import 'matching/request.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: buildAppBar(context),
        body: MyWidget(),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: 1,
          onTabSelected: (index) {},
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendRequestsPage()),
            );
          },
        ),
      ],
    );
  }
}
