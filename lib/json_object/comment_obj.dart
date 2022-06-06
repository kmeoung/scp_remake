class CommentObject {
  final int commentId;
  final int taskId;
  final String commentNickname;
  final String commentTime;
  final String commentContent;
  final int commentuserId;

  factory CommentObject.fromJson(Map<String, dynamic> json) {
    return CommentObject(
      json['commentId'],
      json['taskId'],
      json['commentNickname'],
      json['commentTime'],
      json['commentContent'],
      json['commentuserId'],
    );
  }

  CommentObject(this.commentId, this.taskId, this.commentNickname,
      this.commentTime, this.commentContent, this.commentuserId);
}
