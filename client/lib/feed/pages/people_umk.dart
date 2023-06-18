/* import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class PeopleYouMayKnowSection extends StatefulWidget {
  @override
  _PeopleYouMayKnowSectionState createState() =>
      _PeopleYouMayKnowSectionState();
}

class _PeopleYouMayKnowSectionState extends State<PeopleYouMayKnowSection> {
  List<User> peopleYouMayKnow = [];

  @override
  void initState() {
    super.initState();
    fetchPeopleYouMayKnow();
  }

  void fetchPeopleYouMayKnow() async {
    try {
      List<User> users = await UserService.fetchUsersYouMayKnow();
      setState(() {
        peopleYouMayKnow = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: peopleYouMayKnow.length,
        itemBuilder: (BuildContext context, int index) {
          User user = peopleYouMayKnow[index];
          return Container(
            width: 100,
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.profilePictureUrl),
                ),
                SizedBox(height: 8),
                Text(user.name),
              ],
            ),
          );
        },
      ),
    );
  }
}
 */