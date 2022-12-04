import 'package:dartx/dartx.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/star.dart';
import 'package:social_soup/models/user.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.caption,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.title,
    required this.user,
    required this.stars,
    required this.notes,
    required this.image,
    this.userObject,
    this.starObject,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, {User? obj}) {
    print(json['starObject']);
    return Recipe(
      id: json['_id'],
      caption: json['caption'],
      ingredients:
          (json['ingredients'] as List).map((e) => e as String).toList(),
      instructions: json['instructions'],
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      title: json['title'],
      user: json['user'],
      stars: json['stars'],
      notes: json['notes'],
      image: json['image'],
      userObject:
          json['userObject'] != null && (json['userObject'] as List).isNotEmpty
              ? User.fromJson((json['userObject'] as List).first)
              : obj,
      starObject:
          json['starObject'] != null && (json['starObject'] as List).isNotEmpty
              ? Star.fromJson((json['starObject'] as List).first)
              : null,
    );
  }

  ObjectId id;
  String caption;
  List<String> ingredients;
  String instructions;
  List<String> tags;
  String title;
  ObjectId user;
  int stars;
  int notes;
  String image;
  User? userObject;
  Star? starObject;

  toJson() => {
        "_id": id,
        "caption": caption,
        "ingredients": ingredients,
        "instructions": instructions,
        "tags": tags,
        "title": title,
        "user": user,
        "stars": stars,
        "notes": notes,
        'image': image,
      };
}
