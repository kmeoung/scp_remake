class TeamMemberObject {
  final int userId;
  final String userNickname;
  final String teaminuserCommoncode;
  final int teaminuserMaker;

  factory TeamMemberObject.fromJson(Map<String, dynamic> json) {
    return TeamMemberObject(
      json['userId'],
      json['userNickname'],
      json['teaminuserCommoncode'],
      json['teaminuserMaker'],
    );
  }

  TeamMemberObject(this.userId, this.userNickname, this.teaminuserCommoncode,
      this.teaminuserMaker);
}
