import 'package:client/market/market.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      //hedhi heya l animation
                      child: Image.network(
                          "https://cdn.dribbble.com/users/1138069/screenshots/8974973/media/2b32ae97856da7406151c6ae6ea086cc.gif"),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Success !",
                    style: AppFont.bold.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your order will be delivered soon.\n Thank you for choosing SKILLY!!",
                    style: AppFont.regular.copyWith(
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColorRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  textStyle: AppFont.medium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
                child: Text('Thanks skiller'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppFont {
  static final regular = TextStyle(
    fontFamily: 'Metro',
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: 18,
  );

  static final medium = TextStyle(
    fontFamily: 'Metro',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 18,
  );

  static final bold = TextStyle(
    fontFamily: 'Metro',
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 18,
  );
  static final semiBold = TextStyle(
    fontFamily: 'Metro',
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 18,
  );
}

class AppColors {
  static const Color primaryColorRed = Color(0xffDB3022);
  static const Color primaryColorGray = Color(0xff9B9B9B);
}
