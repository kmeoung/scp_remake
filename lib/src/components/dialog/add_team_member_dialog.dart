import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/provider/team_search_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';

/// 팀원 추가 Dialog
class AddTeamMemberDialog extends StatelessWidget {
  // 가로 사이즈
  double width;
  // 세로 사이즈
  double height;
  String uid;
  AddTeamMemberDialog(
      {Key? key, required this.uid, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamSearchController(),
      builder: (context, child) => Consumer(
        builder: (context, value, child) => _customDialog(context),
      ),
    );
  }

  /// Get Team Member
  _getTeamMember(BuildContext context, {required String keyword}) async {
    var url = Comm_Params.URL_SEARCH_USER
        .replaceAll(Comm_Params.USER_ID, uid)
        .replaceAll(Comm_Params.EMAIL_KEYWORD, keyword);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<TeamSearchController>().clear();
        List<dynamic> users = json['emailUser'];
        if (users.isNotEmpty) {
          for (Map<String, dynamic> json in users) {
            SearchUserObject user = SearchUserObject.fromJson(json);
            context.read<TeamSearchController>().add(user);
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

  Timer? _searchTimer;

  // Dialog Contents
  Widget _customDialogContents(BuildContext context) {
    List<SearchUserObject> users = context.watch<TeamSearchController>().get();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(title: 'Team Member Select'),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onChanged: (keyword) {
                  if (_searchTimer != null) _searchTimer!.cancel();

                  if (keyword.isNotEmpty) {
                    _searchTimer = Timer(const Duration(milliseconds: 500),
                            () => _getTeamMember(context, keyword: keyword));
                  } else {
                    _searchTimer = Timer(const Duration(milliseconds: 500),
                            () => context.read<TeamSearchController>().clear());
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search Team Member',
                  hintStyle: TextStyle(
                      color: CustomColors.deepPurple.withOpacity(0.5)),
                  label: null,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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