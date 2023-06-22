import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../feed.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'post_details_age.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Post> _searchResults = [];

  void _performSearch(String query) async {
    if (query.isNotEmpty) {
      try {
        List<Post> allPosts = await PostService.fetchPosts();
        List<Post> results = allPosts.where((post) {
          return post.skill.toLowerCase().contains(query.toLowerCase()) ||
              post.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        // Handle error if the search fails
        print('Search failed: $e');
      }
    }
  }

  void navigateToPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsPage(post: post)),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      // If search is performed and no results are found
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No results found.'),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/search.json',
              width: 200,
              height: 200,
            ),
          ],
        ),
      );
    } else {
      // If there are search results or no search is performed
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              navigateToPost(_searchResults[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _searchResults[index].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _searchResults[index].skill,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _performSearch,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black87,
            ),
            hintText: "Search",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.black87,
            ),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults = [];
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }
}
