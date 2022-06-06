import 'package:flutter/cupertino.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team_member_dialog_obj.dart';

class TeamMemberController extends ChangeNotifier {
  List<TeamMemberDialogObject> mMember = [];

  addMember(TeamMemberDialogObject member) {
    if (!mMember.contains(member)) {
      mMember.add(member);
    }
    notifyListeners();
  }

  removeMember(TeamMemberDialogObject member) {
    if (mMember.contains(member)) {
      mMember.remove(member);
    }
    notifyListeners();
  }

  List<TeamMemberDialogObject> getMember() {
    return mMember;
  }

  changeMemberPermission(int index, MEMBER_PERMISSION permission) {
    mMember[index].projectinuserCommoncode = permission;
    notifyListeners();
  }

  clear() {
    mMember.clear();
    notifyListeners();
  }
}
