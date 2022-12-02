class Note {
  Note({
    required this.id,
    required this.note,
    required this.recipe,
    required this.user,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['_id'],
        note: json['note'],
        recipe: json['recipe'],
        user: json['user'],
      );

  String id;
  String note;
  String recipe;
  String user;

  toJson() => {
        "_id": id,
        "note": note,
        "recipe": recipe,
        "user": user,
      };
}
