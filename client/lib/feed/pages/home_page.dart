import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/other_users.dart';
import '../../market/components/utils/api.dart';
import 'post_details_age.dart';
import 'create_post.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../../market/market.dart';
import '../../bottom_navigation.dart';
import 'search.dart';
import 'categories/des.dart';
import 'categories/gaming.dart';
import 'categories/art.dart';
import 'report.dart';
import 'categories/webanimation.dart';
import 'package:http/http.dart' as http;
import 'package:client/market/matching/request.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = false;
  bool isSocialMediaVisible = false;
  Map<int, bool> likedPosts = {};
  bool isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchFriendRequests();
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Post> fetchedPosts = await PostService.fetchPosts();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;

        likedPosts = Map.fromIterable(
          posts,
          key: (post) => post.id,
          value: (post) => false,
        );
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch posts');
    }
  }

  Future<void> likePost(int postId) async {
    try {
      await PostService.likePost(postId);
      setState(() {
        likedPosts[postId] = true;
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].likes++;
        }
      });
    } catch (error) {
      print('Failed to like the post: $error');
    }
  }

  Future<void> unlikePost(int postId) async {
    try {
      await PostService.unlikePost(postId);
      setState(() {
        likedPosts[postId] = false;
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].likes--;
        }
      });
    } catch (error) {
      print('Failed to unlike the post: $error');
    }
  }

  int friendRequestsCount = 0;
  Future<void> fetchFriendRequests() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${localhost}:3001/match/friendships/get/${FirebaseAuth.instance.currentUser?.uid}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List<dynamic>) {
          setState(() {
            friendRequestsCount = data.length;
          });
        } else {
          print('Invalid friend requests data');
        }
      } else {
        print('Failed to fetch friend requests. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch friend requests. Error: $error');
    }
  }

  void navigateToPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsPage(post: post)),
    );
  }

  void navigateToCreatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostFeed()),
    );
  }

  void navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserProfileWidget(userId: userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled
          ? const Color.fromARGB(255, 40, 40, 40)
          : const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        leading: Switch(
          value: isDarkModeEnabled,
          onChanged: (value) {
            setState(() {
              isDarkModeEnabled = value;
            });
          },
          activeColor: isDarkModeEnabled
              ? Colors.white
              : Color.fromARGB(255, 23, 23, 23),
        ),
        backgroundColor: isDarkModeEnabled
            ? const Color.fromARGB(255, 40, 40, 40)
            : const Color.fromRGBO(244, 243, 243, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: isDarkModeEnabled
                ? Colors.white
                : Color.fromARGB(255, 40, 40, 40),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendRequestsPage()),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Image.asset(
          'assets/images/skilly1.png',
          height: 150,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkModeEnabled
                      ? const Color.fromARGB(255, 40, 40, 40)
                      : const Color.fromRGBO(244, 243, 243, 1),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isDarkModeEnabled
                            ? Colors.white
                            : Color.fromARGB(255, 23, 23, 23),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()),
                          );
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDarkModeEnabled
                                ? Color.fromARGB(255, 23, 23, 23)
                                : Colors.white,
                          ),
                          hintText: "Search you're looking for",
                          hintStyle: TextStyle(
                              color: isDarkModeEnabled
                                  ? Color.fromARGB(255, 23, 23, 23)
                                  : Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Popular',
                      style: TextStyle(
                          color: isDarkModeEnabled
                              ? Colors.white
                              : Color(0xFF284855),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          promoCard(
                            'assets/images/webD.jpg',
                            'Web Development',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebAnimation()),
                              );
                            },
                          ),
                          promoCard(
                            'assets/images/GraphicD.jpg',
                            'Graphic Design',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DesPage()),
                              );
                            },
                          ),
                          promoCard(
                            'assets/images/Gaming.jpg',
                            'Gaming',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GamingPage()),
                              );
                            },
                          ),
                          promoCard(
                            'assets/images/art1.jpg',
                            'ArtWorks',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/takealook.png'),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              stops: const [0.3, 0.9],
                              colors: [
                                Colors.black.withOpacity(.8),
                                Colors.black.withOpacity(.2),
                              ],
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'Take a Look at the marketplace ! ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore',
                                style: TextStyle(
                                    color: isDarkModeEnabled
                                        ? Colors.white
                                        : Color(0xFF284855),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => navigateToPost(posts[index]),
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 20.0),
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(posts[index].image),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomRight,
                                            stops: const [0.3, 0.9],
                                            colors: [
                                              Colors.black.withOpacity(.8),
                                              Colors.black.withOpacity(.2),
                                            ],
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    posts[index]
                                                        .user
                                                        .profileImage),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserProfileWidget(
                                                              userId:
                                                                  posts[index]
                                                                      .user
                                                                      .id)),
                                                );
                                              },
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20, left: 60),
                                                  child: Text(
                                                    posts[index].user.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                color: Colors.white,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Options'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ReportDialog(
                                                                      onSend:
                                                                          (selectedOptions) {
                                                                        print(
                                                                            selectedOptions);
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: const Text(
                                                                '🏴Report',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF284855),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      posts[index].title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      posts[index].desc,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Skill: ${posts[index].skill}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            likedPosts[posts[
                                                                            index]
                                                                        .id] ??
                                                                    false
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            color: likedPosts[posts[
                                                                            index]
                                                                        .id] ??
                                                                    false
                                                                ? Colors.red
                                                                : Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            if (likedPosts[
                                                                    posts[index]
                                                                        .id] ??
                                                                false) {
                                                              unlikePost(
                                                                  posts[index]
                                                                      .id);
                                                            } else {
                                                              likePost(
                                                                  posts[index]
                                                                      .id);
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          '${posts[index].likes}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.comment,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            navigateToPost(
                                                                posts[index]);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTabSelected: (index) {},
      ),
    );
  }

  Widget promoCard(image, label, {VoidCallback? onTap}) {
    return AspectRatio(
      aspectRatio: 2.62 / 3,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.2),
              ]),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
