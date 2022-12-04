import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/user.dart';

class Note {
  Note({
    required this.id,
    required this.note,
    required this.recipe,
    required this.user,
    this.userObject,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['_id'],
        note: json['note'],
        recipe: json['recipe'],
        user: json['user'],
        userObject: json['userObject'] != null &&
                (json['userObject'] as List).isNotEmpty
            ? User.fromJson((json['userObject'] as List).first)
            : null,
      );

  ObjectId id;
  String note;
  ObjectId recipe;
  ObjectId user;
  User? userObject;

  toJson() => {
        "_id": id,
        "note": note,
        "recipe": recipe,
        "user": user,
      };
}
