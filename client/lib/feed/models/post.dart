import 'user.dart';

class Post {
  final int id;
  final String image;
  final String title;
  final String desc;
  final User user;
  late final int likes;

  Post({
    required this.id,
    required this.image,
    required this.title,
    required this.desc,
    required this.user,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      desc: json['desc'],
      user: User.fromJson(json['user']),
      likes: json['likes'],
    );
  }
}
