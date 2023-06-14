import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import './complete.dart';

final List<String> hobbiesInterests = [
  "📸 Photography",
  "🎭 Theaters",
  "🖼️ Exhibitions",
  "🍳 Cooking",
  "☕ Coffee",
  "🖍️ Design",
  "👗 Fashion",
  "📚 Reading",
  "💃 Dance",
  "🏺 Pottery",
  "🎨 Drawing",
  "💋 Beauty",
  "📖 Journalling",
  "🎮 Gaming",
  "🎯 Sports",
  "🎲 Board Games",
  "🌿 Gardening",
  "🎵 Music",
  "🧠 Mindfulness",
];

final List<String> skillsInterests = [
  "💻 Coding",
  "👨‍💻 Programming",
  "💰 Finance",
  "📊 Accounting",
  "🎨 Design",
  "📈 Marketing",
  "📷 Photography",
  "📝 Writing",
  "📐 Architecture",
  "🔬 Science",
  "🧪 Chemistry",
  "🧮 Mathematics",
  "🌐 Web Development",
  "📚 Research",
  "🔌 Electrical Engineering",
];

List<String> chosenHobbiesInterests = [];
List<String> chosenSkillsInterests = [];

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  bool buttonHovered = false;
  String _errorMessage = '';

  Future<void> saveUserInterests() async {
    final user = FirebaseAuth.instance.currentUser;
    print(FirebaseAuth.instance.currentUser);
    if (user != null) {
      final userId = user.email;

      final interestsData = {
        'hobbies': chosenHobbiesInterests,
        'skills': chosenSkillsInterests,
      };

      final url = Uri.parse('http://10.0.2.2:3001/api/$userId');
      final response = await http.put(
        url,
        body: jsonEncode(interestsData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {

        // Interests saved successfully
        print('Interests saved successfully');
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(),
        ),
      );
      } else {
        // Failed to save interests
        print('Failed to save interests');
        setState(() {
          _errorMessage = "Failed to save interests. Please try again later.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              'Choose Your Interests',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InterestsSection(
              title: 'Hobbies',
              interests: hobbiesInterests,
              selectedInterests: chosenHobbiesInterests,
              onInterestSelected: (interest) {
                setState(() {
                  if (chosenHobbiesInterests.contains(interest)) {
                    chosenHobbiesInterests.remove(interest);
                  } else {
                    chosenHobbiesInterests.add(interest);
                  }
                });
              },
            ),
            InterestsSection(
              title: 'Skills',
              interests: skillsInterests,
              selectedInterests: chosenSkillsInterests,
              onInterestSelected: (interest) {
                setState(() {
                  if (chosenSkillsInterests.contains(interest)) {
                    chosenSkillsInterests.remove(interest);
                  } else {
                    chosenSkillsInterests.add(interest);
                  }
                });
              },
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                saveUserInterests();
                print(FirebaseAuth.instance.currentUser?.uid);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonHovered
                      ? Colors.grey.withOpacity(0.8)
                      : Color.fromARGB(255, 20, 3, 46),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.double_arrow,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
              onHover: (value) {
                setState(() {
                  buttonHovered = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InterestsSection extends StatelessWidget {
  final String title;
  final List<String> interests;
  final List<String> selectedInterests;
  final Function(String) onInterestSelected;

  InterestsSection({
    required this.title,
    required this.interests,
    required this.selectedInterests,
    required this.onInterestSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: interests.map((interest) {
            final isSelected = selectedInterests.contains(interest);
            return ChoiceChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (_) => onInterestSelected(interest),
              selectedColor: Color.fromARGB(255, 7, 52, 88),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'SKILLY',
    home: InterestsPage(),
  ));
}
