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
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['_id'],
        caption: json['caption'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        tags: json['tags'],
        title: json['title'],
        user: json['user'],
        stars: json['stars'],
        notes: json['notes'],
      );

  String id;
  String caption;
  List<String> ingredients;
  String instructions;
  List<String> tags;
  String title;
  String user;
  int stars;
  int notes;

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
      };
}
