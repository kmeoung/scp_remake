import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team/team_dialog_obj.dart';
import 'package:refactory_scp/provider/team_dialog_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';

/// 팀 추가 Dialog
class AddTeamDialog extends StatelessWidget {
  // 가로 사이즈
  double width;

  // 세로 사이즈
  double height;
  String uid;

  AddTeamDialog(
      {Key? key, required this.uid, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _customDialog(context);
  }

  _getTeam(BuildContext context) {
    var url = Comm_Params.URL_TEAM_LIST.replaceAll(Comm_Params.USER_ID, uid);
    ScpHttpClient.get(url, onSuccess: (json, message) {
      List<dynamic> teams = json['teams'];
      context.read<TeamDialogController>().clear();
      for (Map<String, dynamic> team in teams) {
        TeamDialogObject tdo = TeamDialogObject.fromJson(team);
        context.read<TeamDialogController>().add(tdo);
      }
    });
  }

  _getTeamMember(BuildContext context, int teamId) {
    var url = Comm_Params.URL_TEAM_MEMBER_LIST
        .replaceAll(Comm_Params.TEAM_ID, teamId.toString());

    ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        List<dynamic> members = json['members'];
        List<SearchUserObject> returnList = [];
        for (Map<String, dynamic> member in members) {
          SearchUserObject suo =
              SearchUserObject(member['userId'], member['userNickname'], '');

          returnList.add(suo);
        }

        Navigator.pop(context, returnList);
      },
    );
  }

  // Dialog Contents
  Widget _customDialogContents(BuildContext context) {
    return ChangeNotifierProvider<TeamDialogController>(
      create: (_) => TeamDialogController(),
      builder: (BuildContext context, Widget? child) {
        _getTeam(context);

        return Consumer<TeamDialogController>(
          builder: (context, value, child) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Team Select'),
                Expanded(
                  child: ListView(
                    children: List.generate(
                      context.watch<TeamDialogController>().teams.length,
                      (index) {
                        TeamDialogObject team =
                            context.watch<TeamDialogController>().teams[index];
                        return ListTile(
                          onTap: () {
                            _getTeamMember(context, team.teamId);
                          },
                          leading: const CircleAvatar(
                            backgroundColor: CustomColors.deepPurple,
                            foregroundColor: Colors.transparent,
                          ),
                          title: Text(
                            team.teamName,
                            style: TextStyle(color: CustomColors.deepPurple),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Dialog 전체
  Widget _customDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: width,
        height: height,
        child: _customDialogContents(context),
      ),
    );
  }
}
