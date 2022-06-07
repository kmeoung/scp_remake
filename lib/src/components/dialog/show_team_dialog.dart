import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team/team_dialog_obj.dart';
import 'package:refactory_scp/provider/show_team_dialog_controller.dart';
import 'package:refactory_scp/provider/team_dialog_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/add_pages/add_or_edit_team.dart';

/// 팀 dialog
class ShowTeamDialog extends StatelessWidget {
  // 가로 사이즈
  double width;

  // 세로 사이즈
  double height;
  String uid;
  String tName;
  int tid;

  ShowTeamDialog(
      {Key? key,
      required this.tName,
      required this.tid,
      required this.uid,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _customDialog(context);
  }

  _getTeamMember(BuildContext context, int teamId) {
    var url = Comm_Params.URL_TEAM_MEMBER_LIST
        .replaceAll(Comm_Params.TEAM_ID, teamId.toString());

    ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        List<dynamic> members = json['members'];
        for (Map<String, dynamic> member in members) {
          SearchUserObject suo =
              SearchUserObject(member['userId'], member['userNickname'], '');
          context.read<ShowTeamDialogController>().add(suo);
        }
      },
    );
  }

  // Dialog Contents
  Widget _customDialogContents(BuildContext context) {
    return ChangeNotifierProvider<ShowTeamDialogController>(
      create: (_) => ShowTeamDialogController(),
      builder: (BuildContext context, Widget? child) {
        _getTeamMember(context, tid);

        return Consumer<ShowTeamDialogController>(
          builder: (context, value, child) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(
                  title: tName,
                  onTapMore: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddOrEditTeam(
                          uid: uid,
                          tid: '$tid',
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: ListView(
                    children: List.generate(
                      context.watch<ShowTeamDialogController>().member.length,
                      (index) {
                        SearchUserObject member = context
                            .watch<ShowTeamDialogController>()
                            .member[index];
                        return ListTile(
                          onTap: null,
                          leading: const CircleAvatar(
                            backgroundColor: CustomColors.deepPurple,
                            foregroundColor: Colors.transparent,
                          ),
                          title: Text(
                            member.userNickname,
                            style:
                                const TextStyle(color: CustomColors.deepPurple),
                          ),
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
