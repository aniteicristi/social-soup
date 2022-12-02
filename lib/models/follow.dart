class Follow {
  Follow({
    required this.id,
    required this.followed,
    required this.follower,
  });

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json['id'],
        followed: json['followed'],
        follower: json['follower'],
      );

  String id;
  String followed;
  String follower;

  toJson() => {
        'id': id,
        'followed': followed,
        'follower': follower,
      };
}
