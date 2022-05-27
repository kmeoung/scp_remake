class TaskDetailObject {
  final int taskId;
  final int projectinuserId;
  final String taskOwner_string;
  final String taskContent;
  final int taskRequester;
  final String taskRequester_string;
  int taskComplete;
  final int taskAccept;
  final String taskRequesttime;
  final String taskDeadline;
  final String taskCreatetime;

  TaskDetailObject(
      this.taskId,
      this.projectinuserId,
      this.taskContent,
      this.taskRequester,
      this.taskComplete,
      this.taskAccept,
      this.taskRequesttime,
      this.taskDeadline,
      this.taskCreatetime,
      this.taskOwner_string,
      this.taskRequester_string);
  factory TaskDetailObject.fromJson(Map<String, dynamic> json) {
    return TaskDetailObject(
      json['taskId'],
      json['projectinuserId'],
      json['taskContent'],
      json['taskRequester'],
      json['taskComplete'],
      json['taskAccept'],
      json['taskRequesttime'],
      json['taskDeadline'],
      json['taskCreatetime'],
      json['taskOwner_string'],
      json['taskRequester_string'],
    );
  }
}
