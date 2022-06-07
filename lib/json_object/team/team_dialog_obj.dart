class TeamDialogObject {
  final int teamId;
  final String teamName;

  TeamDialogObject(this.teamId, this.teamName);

  factory TeamDialogObject.fromJson(Map<String, dynamic> json) {
    return TeamDialogObject(json['teamId'], json['teamName']);
  }
}
