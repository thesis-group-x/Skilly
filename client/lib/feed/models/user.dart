class User {
  final int id;
  final String uid;
  final String name;
  final String email;
  final String address;
  final String profileImage;
  final String budge;
  final int points;
  final List<dynamic> skills;
  final List<dynamic> hobbies;
  final String details;
  final String descriptions;
  final String phoneNumber;
  final int level;
  final String createdAt;
  final bool isBanned;
  final bool isAdmin;

  User({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.profileImage,
    required this.budge,
    required this.points,
    required this.skills,
    required this.hobbies,
    required this.details,
    required this.descriptions,
    required this.phoneNumber,
    required this.level,
    required this.createdAt,
    required this.isBanned,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      budge: json['budge'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      skills: json['skills'] as List<dynamic>? ?? [],
      hobbies: json['hobbies'] as List<dynamic>? ?? [],
      details: json['details'] as String? ?? '',
      descriptions: json['descriptions'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      level: json['level'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      isBanned: json['isBanned'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }
}
