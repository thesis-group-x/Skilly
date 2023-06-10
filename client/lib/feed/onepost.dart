import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostItemScreen extends StatefulWidget {
  final int postId;

  const PostItemScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  late Future<post> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = fetchpost();
  }

  Future<post> fetchpost() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3001/feed/${widget.postId}'));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return post.fromJson(data);
    } else {
      throw Exception('Failed to fetch post data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<post>(
      future: postFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Post'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Post'),
            ),
            body: Center(
              child: Text('Failed to fetch post data'),
            ),
          );
        } else {
          final post = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Post'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(post.image),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: primary,
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              post.title,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    post.skill,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Skill",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: SecondaryText),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    post.desc,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: SecondaryText),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 1 / 1.3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class post {
  final String title;
  final String image;
  final String desc;
  final String skill;
  final int userId;

  post({
    required this.title,
    required this.image,
    required this.desc,
    required this.skill,
    required this.userId,
  });

  factory post.fromJson(Map<String, dynamic> json) {
    return post(
      title: json['title'],
      image: json['image'],
      desc: json['desc'],
      skill: json['skill'],
      userId: json['userId'],
    );
  }
}

const Color primary = Color(0xFF1FCC79);
const Color Secondary = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color form = Color(0xFFF4F5F7);
