import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team/team_member_dialog_obj.dart';
import 'package:refactory_scp/provider/team_member_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/dialog/add_team_dialog.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/components/dialog/add_team_member_dialog.dart';
import 'package:refactory_scp/src/pages/home/home_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class AddOrEditProject extends DefaultTemplate {
  final String uid;
  final ProjectObject? project;
  List<TeamMemberDialogObject> _mMember = [];
  final TextEditingController _titleController = TextEditingController();

  AddOrEditProject({required this.uid, this.project, Key? key})
      : super(uid, key: key);
  bool isEdit = false;

  _addProject(BuildContext context) {
    const url = Comm_Params.URL_PROJECT_ADD;

    List<dynamic> newMembers = [];

    for (var element in _mMember) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "projectinuserMaker": uid,
        "projectinuserCommoncode":
            element.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
                ? 'p-leader'
                : 'p-member',
      };
      newMembers.add(member);
    }

    if (_titleController.value.text.isEmpty) {
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

    Map<String, dynamic> body = {
      "title": _titleController.value.text,
      // "userId": int.parse(uid),
      "member": newMembers,
    };

    ScpHttpClient.post(
      url,
      body: body,
      onSuccess: (json, message) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(uid: uid),
            ));
      },
    );
  }

  _patchModidyProject(BuildContext context) {
    if (project == null) return;

    String url = Comm_Params.URL_MODIFY_RPOJECT
        .replaceAll(Comm_Params.PROJECT_ID, '${project!.projectId}');

    List<dynamic> newMembers = [];

    for (var element in _mMember) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "projectinuserMaker": uid,
        "projectinuserCommoncode":
            element.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
                ? 'p-leader'
                : 'p-member',
      };
      newMembers.add(member);
    }

    if (_titleController.value.text.isEmpty) {
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

    Map<String, dynamic> body = {
      "title": _titleController.value.text,
      // "userId": int.parse(uid),
      "member": newMembers,
    };

    ScpHttpClient.patch(
      url,
      body: body,
      onSuccess: (json, message) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(uid: uid),
            ));
      },
    );
  }

  @override
  Widget customDetail(ScrollController controller, BuildContext context) {
    isEdit = project != null;
    return ChangeNotifierProvider(
      create: (_) => TeamMemberController(),
      builder: (context, child) {

        var member = TeamMemberDialogObject(
            '본인', int.parse(uid), int.parse(uid), MEMBER_PERMISSION.LEADER);
        context.read<TeamMemberController>().addMember(member);
        if (isEdit) {
          if(project!.projectName.isEmpty) _titleController.text = project!.projectName;
        }
        _mMember = context.watch<TeamMemberController>().getMember();
        return Consumer<TeamMemberController>(
          builder: (context, value, child) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContentTitle(
                    title: '${isEdit ? 'Edit' : 'Add'} Project',
                  ),
                  _header('Input Project Title'),
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
          controller: _titleController,
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
                int.parse(uid), MEMBER_PERMISSION.MEMBER);
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
              result.userId, int.parse(uid), MEMBER_PERMISSION.MEMBER);
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
                    visible: isEdit
                        ? false
                        : member.projectinuserCommoncode !=
                            MEMBER_PERMISSION.LEADER,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        context
                            .read<TeamMemberController>()
                            .removeMember(member);
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
              alignment: Alignment.centerLeft,
              height: 50,
              width: double.infinity,
              child: Text(
                member.projectinuserCommoncode == MEMBER_PERMISSION.LEADER
                    ? '생성자'
                    : '멤버',
                style: const TextStyle(
                    color: CustomColors.deepPurple, fontSize: 12),
              ),
            ),
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
          _patchModidyProject(context);
        } else {
          _addProject(context);
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
