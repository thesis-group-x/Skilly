import 'package:flutter/material.dart';

final List<String> hobbiesInterests = [
  "📸 Photography",
  "🎭 Theaters",
  "🖼️ Exhibitions",
  "📐 Architecture",
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
  "🎵 Music",
  "🧠 Mindfulness",
  "🍳 Cooking",
];

List<String> chosenHobbiesInterests = [];
List<String> chosenSkillsInterests = [];

class InterestsPage extends StatelessWidget {
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
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

  InterestsSection({
    Key? key,
    required this.title,
    required this.interests,
    required this.chosenInterests,
  }) : super(key: key);

  @override
  _InterestsSectionState createState() => _InterestsSectionState();
}

class _InterestsSectionState extends State<InterestsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.interests.map((interest) {
            bool isChosen = widget.chosenInterests.contains(interest);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isChosen) {
                    widget.chosenInterests.remove(interest);
                  } else {
                    widget.chosenInterests.add(interest);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isChosen
                      ? const Color.fromARGB(255, 14, 41, 64)
                      : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      interest.substring(2), // Remove the emoji from the interest text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' ${interest.substring(0, 2)}', // Extract the emoji from the interest text
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
