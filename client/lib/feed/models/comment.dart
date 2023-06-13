class Comment {
  final int id;
  final String text;
  final int postId;
  final int userId;

  Comment({
    required this.id,
    required this.text,
    required this.postId,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      postId: json['postId'],
      userId: json['userId'],
    );
  }
}
