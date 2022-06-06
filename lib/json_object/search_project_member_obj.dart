enum MEMBER_PERMISSION { P_LEADER, P_MEMBER }

class SearchProjectMemberObject {
  final int id;
  final String userNickname;
  final String userEmail;
  final String userSnstype;
  final String userRole;
  MEMBER_PERMISSION permission = MEMBER_PERMISSION.P_MEMBER;

  factory SearchProjectMemberObject.fromJson(Map<String, dynamic> json) {
    return SearchProjectMemberObject(
      json['id'],
      json['userNickname'],
      json['userEmail'],
      json['userSnstype'],
      json['userRole'],
    );
  }

  SearchProjectMemberObject(this.id, this.userNickname, this.userEmail,
      this.userSnstype, this.userRole);
}
