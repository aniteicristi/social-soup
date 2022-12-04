import 'package:mongo_dart/mongo_dart.dart';

class Follow {
  Follow({
    required this.id,
    required this.followed,
    required this.follower,
  });

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json['_id'],
        followed: json['followed'],
        follower: json['follower'],
      );

  ObjectId id;
  ObjectId followed;
  ObjectId follower;

  toJson() => {
        'id': id,
        'followed': followed,
        'follower': follower,
      };
}
