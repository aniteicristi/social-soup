import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/follow.dart';

class User {
  User({
    required this.id,
    required this.email,
    required this.followers,
    required this.followes,
    required this.joinedAt,
    required this.recipes,
    required this.auth_id,
    required this.handle,
    this.followList,
  });

  String get profilePicture =>
      'https://avatars.dicebear.com/api/big-smile/${handle}.svg';

  factory User.fromJson(Map<String, dynamic> json) {
    print(json['followList']);
    return User(
      id: json['_id'],
      email: json['email'],
      handle: json['handle'],
      followers: json['followers'],
      followes: json['followes'],
      joinedAt: json['joinedAt'],
      recipes: json['recipes'],
      auth_id: json['auth_id'],
      followList: json['followList'] != null
          ? (json['followList'] as List).map((e) => Follow.fromJson(e)).toList()
          : null,
    );
  }

  ObjectId id;
  String email;
  int followers;
  int followes;
  DateTime joinedAt;
  int recipes;
  String auth_id;
  String handle;
  List<Follow>? followList;

  toJson() => {
        '_id': id,
        'email': email,
        'followers': followers,
        'followes': followes,
        'joinedAt': joinedAt,
        'recipes': recipes,
        'auth_id': auth_id,
        'handle': handle,
      };
}
