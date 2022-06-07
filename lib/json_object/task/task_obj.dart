class TaskObject {
  final int taskId;
  final int projectinuserId;
  final String taskContent;
  final int taskRequester;
  final int taskComplete;
  final int taskAccept;
  final String taskRequesttime;
  final String taskDeadline;
  final String taskCreatetime;

  TaskObject(
      this.taskId,
      this.projectinuserId,
      this.taskContent,
      this.taskRequester,
      this.taskComplete,
      this.taskAccept,
      this.taskRequesttime,
      this.taskDeadline,
      this.taskCreatetime);
  factory TaskObject.fromJson(Map<String, dynamic> json) {
    return TaskObject(
      json['taskId'],
      json['projectinuserId'],
      json['taskContent'],
      json['taskRequester'],
      json['taskComplete'],
      json['taskAccept'],
      json['taskRequesttime'],
      json['taskDeadline'],
      json['taskCreatetime'],
    );
  }
}
