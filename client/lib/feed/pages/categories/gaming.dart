import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/post.dart';
import '../../services/post_service.dart';
import '../../feed.dart';
import '../post_details_age.dart';

void main() => runApp(MaterialApp(
      home: GamingPage(),
      debugShowCheckedModeBanner: false,
    ));

class GamingPage extends StatefulWidget {
  @override
  _GamingPageState createState() => new _GamingPageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _GamingPageState extends State<GamingPage> {
  var currentPage = images.length - 1.0;
  List<Post> trendingGamingPosts = [];
  List<Post> favouriteGamingPosts = [];

  @override
  void initState() {
    super.initState();
    fetchRandomGamingPosts();
    fetchGamingPosts();
  }

  Future<void> fetchRandomGamingPosts() async {
    try {
      final List<Post> allPosts = await PostService.getPostsBySkill("🎮 Gaming");
      final random = Random();
      final randomPosts = List<Post>.generate(
        3,
        (index) => allPosts[random.nextInt(allPosts.length)],
      );
      setState(() {
        trendingGamingPosts = randomPosts;
      });
    } catch (error) {
      print("Failed to fetch trending Des posts: $error");
    }
  }

  Future<void> fetchGamingPosts() async {
    try {
      final List<Post> posts = await PostService.getPostsBySkill("🎮 Gaming");
      setState(() {
        favouriteGamingPosts = posts;
      });
    } catch (error) {
      print("Failed to fetch favourite Des posts: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSocialMediaVisible = false;
    void navigateToPost(Post post) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostDetailsPage(post: post)),
      );
    }

    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF284855),
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Feed()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Trending",
                    style: TextStyle(
                                color : Color(0xFF284855),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                CardScrollWidget(currentPage, trendingGamingPosts),
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: images.length,
                    controller: controller,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Explore",
                    style: TextStyle(
                                color : Color(0xFF284855),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Container(
                height: 300.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favouriteGamingPosts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => navigateToPost(favouriteGamingPosts[index]),
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(favouriteGamingPosts[index].image),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              stops: [0.3, 0.9],
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
                                    favouriteGamingPosts[index].user.profileImage,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 60,
                                child: Text(
                                  favouriteGamingPosts[index].user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Options'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  // Handle "Not Interested" option
                                                  Navigator.of(context).pop();
                                                  print('Not Interested');
                                                },
                                                child: Text('Not Interested'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Handle "Report" option
                                                  Navigator.of(context).pop();
                                                  print('Report');
                                                },
                                                child: Text('Report'),
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        favouriteGamingPosts[index].title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        favouriteGamingPosts[index].desc,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // Handle like button action
                                            },
                                          ),
                                          Text(
                                            '${favouriteGamingPosts[index].likes}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
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
                                              icon: Icon(
                                                Icons.share,
                                                color: Colors.white,
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
                                            visible: isSocialMediaVisible,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.facebook,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {},
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  final currentPage;
  final List<Post> posts;

  const CardScrollWidget(this.currentPage, this.posts);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          List<Widget> cardList = [];
          for (var i = 0; i < posts.length; i++) {
            var delta = i - currentPage;
            bool isOnRight = delta > 0;

            var start = padding +
                max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 15 : 1),
                    0.0);

            var cardItem = Positioned.directional(
              top: padding + 20.0 * max(-delta, 0.0),
              bottom: padding + 20.0 * max(-delta, 0.0),
              start: start,
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        posts[i].image,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                posts[i].title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontFamily: "SF-Pro-Text-Regular"),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF284855),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Show more",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        },
      ),
    );
  }
}

const List<String> images = [
  "https://example.com/image1.jpg",
  "https://example.com/image2.jpg",
  "https://example.com/image3.jpg",
];

const double padding = 20.0;
