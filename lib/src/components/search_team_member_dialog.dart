import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_project_member_obj.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/provider/search_project_member_controller.dart';
import 'package:refactory_scp/provider/team_search_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';

import 'content_title.dart';

/// 팀원 추가 Dialog
class SearchTeamMemberDialog extends StatelessWidget {
  final String pid;

  // 가로 사이즈
  double width;

  // 세로 사이즈
  double height;

  SearchTeamMemberDialog(
      {Key? key, required this.pid, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProjectMemeberController(),
      builder: (context, child) {
        _getTeamMember(context);
        return Consumer(
          builder: (context, value, child) => _customDialog(context),
        );
      },
    );
  }

  /// Get Team Member
  _getTeamMember(BuildContext context) async {
    var url =
        Comm_Params.URL_PROJECT_MEMBER.replaceAll(Comm_Params.PROJECT_ID, pid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<SearchProjectMemeberController>().clear();
        List<dynamic> users = json['userlist'];
        if (users.isNotEmpty) {
          for (Map<String, dynamic> json in users) {
            SearchProjectMemberObject user =
                SearchProjectMemberObject.fromJson(json);
            context.read<SearchProjectMemeberController>().add(user);
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

  // Dialog Contents
  Widget _customDialogContents(BuildContext context) {
    List<SearchProjectMemberObject> users =
        context.watch<SearchProjectMemeberController>().get();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(title: 'Project Member Select'),
          Expanded(
            child: ListView(
              children: List.generate(
                users.length,
                (index) => ListTile(
                  onTap: () {
                    Navigator.pop(context, users[index]);
                  },
                  leading: const CircleAvatar(
                    backgroundColor: CustomColors.deepPurple,
                    foregroundColor: Colors.transparent,
                  ),
                  title: Text(
                    users[index].userNickname,
                    style: const TextStyle(color: CustomColors.deepPurple),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          )
        ],
      ),
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
