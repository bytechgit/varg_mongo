class Comment {
  //String _id;
  String text;
  late String created_at;
  String author;
  String author_name;
  String user_id;
  String profile_pictrue;
  double rate;

  Comment(
      {required this.text,
      required this.user_id,
      required this.profile_pictrue,
      required this.rate,
      required this.author,
      required this.author_name}) {
    created_at = DateTime.now().toString();
  }
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'created_at': created_at,
      'author': author,
      'author_name': author_name,
      'user_id': user_id,
      'profile_pictrue': profile_pictrue,
      'rate': rate,
      //'_id': _id  //mozda ne treba
    };
  }

  Comment.fromMap(Map<String, dynamic> map)
      : text = map["text"],
        created_at = map["created_at"],
        author = map["author"],
        author_name = map["author_name"],
        user_id = map["user_id"],
        profile_pictrue = map["profile_pictrue"],
        rate = ((map["rate"]) ?? 0).toDouble();
  //_id = map["_id"];
}
