class TeamObject {
  final int teamId;
  final String teamName;
  final List<dynamic> teamMembers;

  factory TeamObject.fromJson(Map<String, dynamic> json) {
    return TeamObject(
      json['teamId'],
      json['teamName'],
      json['teamMembers'],
    );
  }

  TeamObject(this.teamId, this.teamName, this.teamMembers);
}
