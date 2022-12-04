import 'package:mongo_dart/mongo_dart.dart';

class Star {
  Star({
    required this.id,
    required this.user,
    required this.recipe,
  });

  factory Star.fromJson(Map<String, dynamic> json) => Star(
        id: json['_id'],
        user: json['user'],
        recipe: json['recipe'],
      );

  ObjectId id;
  ObjectId user;
  ObjectId recipe;

  toJson() => {
        'id': id,
        'user': user,
        'recipe': recipe,
      };
}
