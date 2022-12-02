class User {
  User({
    required this.id,
    required this.email,
    required this.followers,
    required this.followes,
    required this.joinedAt,
    required this.recipes,
    required this.auth_id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        email: json['email'],
        followers: json['followers'],
        followes: json['followes'],
        joinedAt: DateTime.parse(json['joinedAt']),
        recipes: json['recipes'],
        auth_id: json['auth_id'],
      );

  String id;
  String email;
  int followers;
  int followes;
  DateTime joinedAt;
  int recipes;
  String auth_id;

  toJson() => {
        '_id': id,
        'email': email,
        'followers': followers,
        'followes': followes,
        'joinedAt': joinedAt,
        'recipes': recipes,
        'auth_id': auth_id,
      };
}
