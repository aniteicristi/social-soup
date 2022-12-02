class Star {
  Star({
    required this.id,
    required this.user,
    required this.recipe,
  });

  factory Star.fromJson(Map<String, dynamic> json) => Star(
        id: json['id'],
        user: json['user'],
        recipe: json['recipe'],
      );

  String id;
  String user;
  String recipe;

  toJson() => {
        'id': id,
        'user': user,
        'recipe': recipe,
      };
}
