// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../utils/api.dart';

// class HeaderWithSearchBox extends StatefulWidget {
//   const HeaderWithSearchBox({
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   _HeaderWithSearchBoxState createState() => _HeaderWithSearchBoxState();
// }

// class _HeaderWithSearchBoxState extends State<HeaderWithSearchBox> {
//   // late User? _user;
//   // int _points = 0;
//   // int _level = 0;
//   // String _badge = '';

//   @override
//   void initState() {
//     super.initState();
//     // _user = FirebaseAuth.instance.currentUser;
//     // _fetchUserData(_user!.uid); // Fetch user data from API
//   }

//   // Future<void> _fetchUserData(String uid) async {
//   //   try {
//   //     final response =
//   //         await http.get(Uri.parse('http://${localhost}:3001/user/uid/$uid'));
//   //     if (response.statusCode == 200) {
//   //       final userData = json.decode(response.body);
//   //       setState(() {
//   //         _points = userData['points'];
//   //         _level = userData['level'];
//   //         _badge = userData['budge'];
//   //       });
//   //       print('thi siss $_badge');
//   //     } else {
//   //       print('Failed to fetch user data');
//   //     }
//   //   } catch (error) {
//   //     print('Error: $error');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
//       height: widget.size.height * 0.2,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//               left: kDefaultPadding,
//               right: kDefaultPadding,
//               bottom: 20 + kDefaultPadding,
//             ),
//             height: widget.size.height * 0.2 - 107,
//             decoration: BoxDecoration(
//               color: kPrimaryColor,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(36),
//                 bottomRight: Radius.circular(36),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//               padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//               height: 54,
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, 10),
//                     blurRadius: 50,
//                     color: kPrimaryColor.withOpacity(0.23),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) {},
//                       decoration: InputDecoration(
//                         hintText: "Search",
//                         hintStyle: TextStyle(foreground: Paint()),
//                       ),
//                     ),
//                   ),
//                   SvgPicture.asset("assets/icons/search.svg"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// const kPrimaryColor = Colors.blueGrey;
// const kDefaultPadding = 20.0;
