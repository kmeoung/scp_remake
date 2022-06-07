import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/team/team_member_obj.dart';
import 'package:refactory_scp/json_object/team/team_obj.dart';
import 'package:refactory_scp/provider/team_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/add_pages/add_or_edit_team.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class TeamPage extends DefaultTemplate {
  final String uid;

  TeamPage({required this.uid, Key? key}) : super(uid, key: key);

  Widget customDetail(ScrollController controller, BuildContext context) {
    return ChangeNotifierProvider<TeamController>(
      create: (_) => TeamController(),
      builder: (context, child) {
        _getTeam(context);
        return Consumer<TeamController>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentTitle(title: 'My Team'),
                    _homeItemView(
                      context,
                      context.watch<TeamController>().myTeam,
                      true,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ContentTitle(title: 'Shared Team'),
                    _homeItemView(
                      context,
                      context.watch<TeamController>().anotherTeam,
                      false,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Get Server
  _getTeam(BuildContext context) async {
    var url = Comm_Params.URL_TEAM.replaceAll(Comm_Params.USER_ID, uid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<TeamController>().clear(teamType: TEAM_TYPE.ALL);
        var team = json['teamHome'];
        if (team['myTeams'].isNotEmpty) {
          for (dynamic team in team['myTeams']) {
            context.read<TeamController>().add(
                TeamObject.fromJson(team as Map<String, dynamic>),
                teamType: TEAM_TYPE.MY);
          }
        }
        if (team['sharedTeams'].isNotEmpty) {
          for (dynamic team in team['sharedTeams']) {
            context.read<TeamController>().add(
                TeamObject.fromJson(team as Map<String, dynamic>),
                teamType: TEAM_TYPE.ANOTHER);
          }
        }
      },
      onFailed: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
            //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
            SnackBar(
          content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
          duration: Duration(seconds: 5), //올라와있는 시간
          action: SnackBarAction(
            //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
            label: 'close', //버튼이름
            onPressed: () {}, //버튼 눌렀을때.
          ),
        ));
      },
    );
  }

  Widget _homeItemView(
      BuildContext context, List<TeamObject> teams, bool isMine) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teams.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 5,
        childAspectRatio: 8 / 8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return _teamCard(context, teams[index], isMine);
      },
    );
  }

  Widget _teamCard(BuildContext context, TeamObject team, bool isMine) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: CustomColors.deepPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 45,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 9.0),
            alignment: Alignment.centerLeft,
            color: Colors.transparent,
            child: SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      team.teamName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Visibility(
                    visible: isMine,
                    child: IconButton(
                      splashRadius: 20,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddOrEditTeam(
                              uid: uid,
                              tid: '${team.teamId}',
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_horiz,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: CustomColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(team.teamMembers.length, (index) {
                  TeamMemberObject member = TeamMemberObject.fromJson(
                      team.teamMembers[index] as Map<String, dynamic>);
                  return Expanded(
                    child: _memberCard(
                        title: member.userNickname,
                        color: CustomColors.deepPurple),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberCard({required String title, required Color color}) {
    return Card(
      elevation: 5.0,
      color: color.withOpacity(0.7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: CustomColors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const CircleAvatar(
              radius: 20,
              backgroundColor: CustomColors.white,
            )
          ],
        ),
      ),
    );
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => AddOrEditTeam(uid: uid)));
      },
      child: const Icon(
        Icons.add,
        color: CustomColors.white,
      ),
      backgroundColor: CustomColors.deepPurple,
    );
  }

  @override
  void initSetting(BuildContext context) {
    // TODO: implement initSetting
  }

  @override
  Widget nonScrollWidget(BuildContext context) {
    // TODO: implement nonScrollWidget
    return Container();
  }
}
