import 'package:flutter/material.dart';

class Skill {
  final String name;
  final String emoji;

  Skill({required this.name, required this.emoji});
}

class SkillsList extends StatelessWidget {
  final List<Skill> skills = [
    Skill(name: "Programming", emoji: "💻"),
    Skill(name: "Design", emoji: "🎨"),
    Skill(name: "Solving", emoji: "🔍"),
    Skill(name: "Communication", emoji: "🗣️"),
    Skill(name: "Teamwork", emoji: "🤝"),
    Skill(name: "Leadership", emoji: "👨‍💼"),
    Skill(name: "Creativity", emoji: "💡"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Row(
          children: skills.map((skill) => SkillButton(skill: skill)).toList(),
        ),
      ),
    );
  }
}

class SkillButton extends StatelessWidget {
  final Skill skill;

  const SkillButton({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: kDefaultPadding),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: CircleBorder(),
                primary: Colors.transparent,
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  skill.emoji,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            skill.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

const kPrimaryColor = Colors.blue; // Replace with your desired primary color
const kDefaultPadding = 20.0; // Replace with your desired default padding value
