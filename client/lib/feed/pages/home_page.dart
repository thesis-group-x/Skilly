// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace, avoid_print, prefer_for_elements_to_map_fromiterable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'post_details_age.dart';
import 'create_post.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../../market/market.dart';
import '../../bottom_navigation.dart';

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

  @override
  void initState() {
    super.initState();
    fetchPosts();
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

  void navigateToPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsPage(post: post)),
    );
  }

  void navigateToCreatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black87,
            ),
            onPressed: navigateToCreatePage,
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Skilly',
          style: TextStyle(
            color: Color(0xFF284855),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                        color: const Color.fromRGBO(244, 243, 243, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black87,
                          ),
                          hintText: "Search you're looking for",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
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
                    const Text(
                      'Popular',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          promoCard(
                              'assets/images/webD.jpg', 'Web Development'),
                          promoCard(
                              'assets/images/GraphicD.jpg', 'Graphic Design'),
                          promoCard('assets/images/gaming.png', 'Gaming'),
                          promoCard('assets/images/webD.jpg', 'Web Dev'),
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
                              const Text(
                                'Explore',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
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
                                            Positioned(
                                              top: 20,
                                              left: 60,
                                              child: Text(
                                                posts[index].user.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                onPressed: () {
                                                  print('Clicked');
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
                                                            // Handle comments action
                                                          },
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 2000,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                isSocialMediaVisible =
                                                                    !isSocialMediaVisible;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              isSocialMediaVisible,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .facebook,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                              )
                                                            ],
                                                          ),
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
          onTabSelected: (index) {
            // Add your logic here based on the selected index
          },
        ),
    );
  }

  Widget promoCard(image, label) {
    return AspectRatio(
      aspectRatio: 2.62 / 3,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
