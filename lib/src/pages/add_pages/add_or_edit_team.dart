import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team/team_member_dialog_obj.dart';
import 'package:refactory_scp/main.dart';
import 'package:refactory_scp/provider/team_member_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/dialog/add_team_dialog.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/components/dialog/add_team_member_dialog.dart';
import 'package:refactory_scp/src/pages/team/team_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class AddOrEditTeam extends DefaultTemplate {
  final String uid;
  final String? tid;

  AddOrEditTeam({required this.uid, this.tid, Key? key}) : super(uid, key: key);

  bool isEdit = false;
  List<TeamMemberDialogObject> _mMemberList = [];

  _postAddTeam(BuildContext context) {
    const url = Comm_Params.URL_TEAM_INSERT;

    if(titleController.value.text.isEmpty){
      Fluttertoast.showToast(
          msg: '제목을 입력해주세요',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    List<dynamic> newMembers = [];
    for (var element in _mMemberList) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "teaminuserMaker":
            element.projectinuserCommoncode == MEMBER_PERMISSION.LEADER ? 1 : 0,
        "teaminuserCommoncode":
            element.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
                ? 't-leader'
                : 't-member',
      };
      newMembers.add(member);
    }

    Map<String, dynamic> body = {
      "teamName": titleController.value.text,
      "teamMembers": newMembers,
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
    );
  }

  _httpModifyTeam(BuildContext context) {
    const url = Comm_Params.URL_TEAM_MODIFY;

    if (tid == null) return;

    if(titleController.value.text.isEmpty){
      Fluttertoast.showToast(
          msg: '제목을 입력해주세요',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    List<dynamic> newMembers = [];
    for (var element in _mMemberList) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "teaminuserCommoncode":
            element.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
                ? 't-leader'
                : 't-member',
      };
      newMembers.add(member);
    }

    Map<String, dynamic> body = {
      "teamId": tid,
      "teamName": titleController.value.text,
      "teamMembers": newMembers,
    };

    ScpHttpClient.put(
      url,
      body: body,
      onSuccess: (json, message) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TeamPage(uid: uid),
            ));
      },
    );
  }

  _getTeamModifyInfo(BuildContext context) {
    String url =
        Comm_Params.URL_TEAM_MODIFY_INFO.replaceAll(Comm_Params.TEAM_ID, tid!);

    ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        Map<String, dynamic> modifyTeamInfo = json['modifyTeamInfo'];
        String teamName = modifyTeamInfo['teamName'];
        titleController.value = TextEditingValue(text: teamName);
        List<dynamic> members = modifyTeamInfo['teamMembers'];
        for(Map<String,dynamic> member in members){
          int userId = member['userId'];
          String userName = member['userNickname'];
          String teaminuserCommoncode = member['teaminuserCommoncode'];
          int teaminuserMaker = member['teaminuserMaker'];

          var tdo = TeamMemberDialogObject(
              teaminuserCommoncode == 't-leader' ? '본인' : userName, userId, teaminuserMaker,teaminuserCommoncode == 't-leader' ? MEMBER_PERMISSION.LEADER : MEMBER_PERMISSION.MEMBER);
          context.read<TeamMemberController>().addMember(tdo);
        }
      },
    );
  }

  @override
  Widget customDetail(ScrollController controller, BuildContext context) {
    isEdit = tid != null;
    return ChangeNotifierProvider(
      create: (_) => TeamMemberController(),
      builder: (context, child) {
        if(isEdit){
          _getTeamModifyInfo(context);
        }else {
          var member = TeamMemberDialogObject(
              '본인', int.parse(uid), 1, MEMBER_PERMISSION.LEADER);
          context.read<TeamMemberController>().addMember(member);
        }

        return Consumer<TeamMemberController>(builder: (context, value, child) {
          _mMemberList = context.watch<TeamMemberController>().getMember();
          return SingleChildScrollView(
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
          );
        });
      },
    );
  }

  TextEditingController titleController = TextEditingController();
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
          controller: titleController,
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
                0, MEMBER_PERMISSION.MEMBER);
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
              result.userId, 0, MEMBER_PERMISSION.MEMBER);
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
                    visible: isEdit ? false : member.projectinuserCommoncode !=
                        MEMBER_PERMISSION.LEADER,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        context.read<TeamMemberController>().removeMember(member);
                      },
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
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  member.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
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
        if (isEdit) {
          _httpModifyTeam(context);
        } else {
          _postAddTeam(context);
        }
      },
      label: Text(
        isEdit ? 'Edit' : 'Create',
        style: const TextStyle(color: CustomColors.white),
      ),
      icon: const Icon(
        Icons.edit,
        color: CustomColors.white,
      ),
      backgroundColor: CustomColors.purple,
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
