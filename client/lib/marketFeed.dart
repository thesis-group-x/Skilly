import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const FeedM());
}

class FeedM extends StatelessWidget {
  const FeedM({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: {
        '/marketFeed': (context) =>
            const MarketFeed(), // Add route for MarketFeed widget
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  Future<List> fetchPosts() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/Market/posts'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: FutureBuilder<List>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var post = snapshot.data?[index];
                return ListTile(
                  leading: Image.network(post['image']),
                  title: Text(post['description']),
                  subtitle: Text('Price: ${post['price']}'),
                  trailing: Text('Skill: ${post['skill']}'),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, '/marketFeed'); // Navigate to marketFeed.dart
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }
}

class MarketFeed extends StatelessWidget {
  const MarketFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Feed'),
      ),
      body: const Center(
        child: Text('This is the Market Feed page'),
      ),
    );
  }
}
