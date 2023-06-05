import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
  "🍳 Cooking",
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

  void saveUserInterests() async {
    final userId = '1'; // Replace with the actual user ID

    // void saveUserInterests() async {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // final User? user = _auth.currentUser;
    // if (user != null) {
    //   final userId = user.uid;

    final interests = {
      'hobbies': chosenHobbiesInterests,
      'skills': chosenSkillsInterests,  
    };

    final url = Uri.parse('http://localhost:3000/api/$userId');
    final response = await http.post(
      url,
      body: interests,
    );

    if (response.statusCode == 200) {
      // Interests saved successfully
      print('Interests saved successfully');
    } else {
      // Failed to save interests
      print('Failed to save interests');
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
                fontFamily: 'Arial', // Replace with your desired font
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
              chosenInterests: chosenHobbiesInterests,
            ),
            SizedBox(height: 40),
            InterestsSection(
              title: 'Skills',
              interests: skillsInterests,
              chosenInterests: chosenSkillsInterests,
            ),
            SizedBox(height: 40),
            Align(
  alignment: Alignment.centerRight,
  child: MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        saveUserInterests();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: buttonHovered ? Colors.grey.withOpacity(0.8) : Colors.black,
          shape: BoxShape.rectangle, // Set the shape to rectangle
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}

class InterestsSection extends StatefulWidget {
  final String title;
  final List<String> interests;
  final List<String> chosenInterests;

  const InterestsSection({
    required this.title,
    required this.interests,
    required this.chosenInterests,
  });

  @override
  _InterestsSectionState createState() => _InterestsSectionState();
}

class _InterestsSectionState extends State<InterestsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial', // Replace with your desired font
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.interests.map((interest) {
            final isSelected = widget.chosenInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    widget.chosenInterests.remove(interest);
                  } else {
                    widget.chosenInterests.add(interest);
                  }
                });
              },
              child: Chip(
                label: Text(
                  interest,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                backgroundColor: isSelected ? Color.fromARGB(255, 23, 6, 54) : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
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