import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team/team_member_dialog_obj.dart';
import 'package:refactory_scp/provider/team_member_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/dialog/add_team_dialog.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/components/dialog/add_team_member_dialog.dart';
import 'package:refactory_scp/src/pages/home/home_page.dart';
import 'package:refactory_scp/src/pages/home/team_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class AddOrEditTeam extends DefaultTemplate {
  final String uid;
  final String? tid;

  AddOrEditTeam({required this.uid, this.tid, Key? key}) : super(uid, key: key);
  String _mTitle = '';
  List<TeamMemberDialogObject> _mMember = [];

  bool isEdit = false;

  _addProject(BuildContext context) {
    const url = Comm_Params.URL_PROJECT_ADD;

    List<dynamic> newMembers = [];

    _mMember.forEach((element) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "projectinuserMaker": uid,
        "projectinuserCommoncode":
            element.projectinuserMaker == MEMBER_PERMISSION.P_LEADER
                ? 'p-leader'
                : 'p-member',
      };
      newMembers.add(member);
    });

    Map<String, dynamic> body = {
      "title": _mTitle,
      "userId": int.parse(uid),
      "member": newMembers,
    };

    ScpHttpClient.post(
      url,
      body: body,
      onSuccess: (json, message) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TeamPage(uid: uid),
            ));
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

  @override
  Widget customDetail(ScrollController controller, BuildContext context) {
    isEdit = tid != null;
    return ChangeNotifierProvider(
      create: (_) => TeamMemberController(),
      builder: (context, child) {
        _mMember.clear();
        var member = TeamMemberDialogObject(
            '본인', int.parse(uid), int.parse(uid), MEMBER_PERMISSION.P_LEADER);
        _mMember.add(member);
        context.read<TeamMemberController>().addMember(member);

        return Consumer<TeamMemberController>(
          builder: (context, value, child) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContentTitle(
                    title: '${isEdit ? 'Edit' : 'Add'} Team',
                  ),
                  _header('Input Team Title'),
                  const SizedBox(
                    height: 20,
                  ),
                  _addTeam(context, 'Add Team'),
                  const SizedBox(
                    height: 20,
                  ),
                  _addTeamMember(context, 'Add Team Member'),
                  const SizedBox(
                    height: 40,
                  ),
                  ...List.generate(
                      context.watch<TeamMemberController>().getMember().length,
                      (index) => Column(
                            children: [
                              _member(
                                  context
                                      .watch<TeamMemberController>()
                                      .getMember()[index],
                                  index,
                                  context),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          )),
                ]..add(
                    const SizedBox(
                      height: 80,
                    ),
                  ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          textInputAction: TextInputAction.next,
          maxLines: null,
          onChanged: (value) {
            _mTitle = value;
          },
          decoration: InputDecoration(
            hintText: title,
            hintStyle:
                TextStyle(color: CustomColors.deepPurple.withOpacity(0.5)),
            label: null,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _addTeam(BuildContext context, String title) {
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          List<SearchUserObject> result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTeamDialog(
                uid: uid,
                width: size.width * 0.7,
                height: size.height * 0.5,
              );
            },
          );

          for (SearchUserObject suo in result) {
            var member = TeamMemberDialogObject(suo.userNickname, suo.userId,
                int.parse(uid), MEMBER_PERMISSION.P_MEMBER);
            _mMember.add(member);
            context.read<TeamMemberController>().addMember(member);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 17),
          child: Text(
            title,
            style: TextStyle(
              color: CustomColors.deepPurple.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addTeamMember(BuildContext context, String title) {
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          SearchUserObject result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTeamMemberDialog(
                uid: uid,
                width: size.width * 0.7,
                height: size.height * 0.5,
              );
            },
          );
          var member = TeamMemberDialogObject(result.userNickname,
              result.userId, int.parse(uid), MEMBER_PERMISSION.P_MEMBER);
          _mMember.add(member);
          context.read<TeamMemberController>().addMember(member);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 17),
          child: Text(
            title,
            style: TextStyle(
              color: CustomColors.deepPurple.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _member(
      TeamMemberDialogObject member, int index, BuildContext context) {
    List<String> _permissions = ['생성자', '멤버'];

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: CustomColors.deepPurple.withOpacity(0.2), width: 1)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: CustomColors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      member.userName,
                      style: const TextStyle(
                          color: CustomColors.white, fontSize: 12),
                    ),
                  ),
                  Visibility(
                    visible: member.projectinuserCommoncode != MEMBER_PERMISSION.P_LEADER,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close,
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        !isMobile ? Flexible(flex: 2, child: Container()) : Container(),
        Flexible(
          flex: 1,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            color: Colors.white,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: Text(
                  member.projectinuserCommoncode == MEMBER_PERMISSION.P_LEADER
                      ? '생성자'
                      : '멤버',
                  style: const TextStyle(
                      color: CustomColors.deepPurple, fontSize: 12),
                )),
          ),
        ),
      ],
    );
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _addProject(context);
      },
      label: Text(
        isEdit ? 'Edit' : 'Create',
        style: const TextStyle(color: CustomColors.white),
      ),
      icon: const Icon(
        Icons.edit,
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
