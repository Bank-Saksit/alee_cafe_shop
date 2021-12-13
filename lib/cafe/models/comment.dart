class Comment {
  final String email;
  final String comment;
  final DateTime time;

  Comment({this.email, this.comment, this.time});

  Comment.fromJson(Map<String,dynamic> parsedJson)
    : email = parsedJson["email"],
      comment = parsedJson["comment"],
      time = DateTime.fromMillisecondsSinceEpoch(parsedJson["time"]);
}