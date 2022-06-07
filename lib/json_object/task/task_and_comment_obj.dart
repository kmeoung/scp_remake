class TaskAndCommentObject {
  final int taskId;
  final int taskOwnerId;
  final String taskOwner_string;
  final String taskRequester_string;
  final String taskContent;
  final String taskDeadline;
  final List<dynamic> commentList;

  factory TaskAndCommentObject.fromJson(Map<String, dynamic> json) {
    return TaskAndCommentObject(
      json['taskId'],
      json['taskOwnerId'],
      json['taskOwner_string'],
      json['taskRequester_string'],
      json['taskContent'],
      json['taskDeadline'],
      json['commentList'],
    );
  }

  TaskAndCommentObject(
      this.taskId,
      this.taskOwnerId,
      this.taskOwner_string,
      this.taskRequester_string,
      this.taskContent,
      this.taskDeadline,
      this.commentList);
}
