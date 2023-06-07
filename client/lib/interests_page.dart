import 'package:flutter/material.dart';
import 'complete.dart';

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
  const InterestsPage({Key? key}) : super(key: key);

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  bool buttonHovered = false;


  

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
            child: const Text(
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InterestsSection(
              title: 'Hobbies',
              interests: hobbiesInterests,
              chosenInterests: chosenHobbiesInterests,
            ),
            const SizedBox(height: 40),
            InterestsSection(
              title: 'Skills',
              interests: skillsInterests,
              chosenInterests: chosenSkillsInterests,
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                     context,
                   MaterialPageRoute(builder: (context) => const Complete()),
                            );
                     },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonHovered
                        ? Colors.grey.withOpacity(0.8)
                        : const Color(0xFF284855),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Row(
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
                    ],
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
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial', // Replace with your desired font
          ),
        ),
        const SizedBox(height: 16),
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
                    color: isSelected ? Colors.white : const Color(0xFF284855),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                backgroundColor:
                    isSelected ? const Color(0xFF284855) : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
