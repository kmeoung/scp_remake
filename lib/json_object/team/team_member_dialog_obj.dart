enum MEMBER_PERMISSION { P_LEADER, P_MEMBER }

class TeamMemberDialogObject {
  final String userName;
  final int userId;
  final int projectinuserMaker;
  MEMBER_PERMISSION projectinuserCommoncode;

  TeamMemberDialogObject(this.userName, this.userId, this.projectinuserMaker,
      this.projectinuserCommoncode);
}
