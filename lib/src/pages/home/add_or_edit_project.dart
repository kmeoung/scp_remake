import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';
import 'package:refactory_scp/json_object/team_member_dialog_obj.dart';
import 'package:refactory_scp/provider/team_member_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/add_team_dialog.dart';
import 'package:refactory_scp/src/components/add_team_member_dialog.dart';
import 'package:refactory_scp/src/components/content_title.dart';
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

    _mMember.forEach((element) {
      Map<String, dynamic> member = {
        "userId": element.userId,
        "projectinuserMaker": uid,
        "projectinuserCommoncode":
            element.projectinuserCommoncode == MEMBER_PERMISSION.P_LEADER
                ? 'p-leader'
                : 'p-member',
      };
      newMembers.add(member);
    });

    Map<String, dynamic> body = {
      "title": _titleController.value.text.isEmpty
          ? ''
          : _titleController.value.text,
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
      onFailed: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
            //SnackBar ??????????????? context??? ?????? BuildContext??? ?????? ????????? ????????? ???????????? ???.
            SnackBar(
          content: Text(message), //snack bar??? ??????. icon, button???????????? ????????????.
          duration: Duration(seconds: 5), //??????????????? ??????
          action: SnackBarAction(
            //????????? ????????? ??????. ??????????????? ???????????? ?????????.
            label: 'close', //????????????
            onPressed: () {}, //?????? ????????????.
          ),
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
        _mMember.clear();
        var member = TeamMemberDialogObject(
            '??????', int.parse(uid), int.parse(uid), MEMBER_PERMISSION.P_LEADER);
        _mMember.add(member);
        context.read<TeamMemberController>().addMember(member);
        if (isEdit) {
          _titleController.text = project!.projectName;
          // project!.
        }

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
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTeamDialog(
                width: size.width * 0.7,
                height: size.height * 0.5,
              );
            },
          );
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
    List<String> _permissions = ['?????????', '??????'];

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
                  IconButton(
                    splashRadius: 20,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: CustomColors.white,
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
              child: DropdownButton(
                dropdownColor: CustomColors.white,
                borderRadius: BorderRadius.circular(10.0),
                isExpanded: true,
                value: _permissions[
                    member.projectinuserCommoncode == MEMBER_PERMISSION.P_LEADER
                        ? 0
                        : 1],
                elevation: 0,
                style: const TextStyle(
                    color: CustomColors.deepPurple, fontSize: 12),
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: CustomColors.deepPurple,
                ),
                underline: Container(),
                onChanged: (String? value) {
                  context.read<TeamMemberController>().changeMemberPermission(
                      index,
                      '?????????' == value
                          ? MEMBER_PERMISSION.P_LEADER
                          : MEMBER_PERMISSION.P_MEMBER);
                },
                alignment: Alignment.centerRight,
                items: _permissions
                    .map<DropdownMenuItem<String>>((String value) =>
                        DropdownMenuItem<String>(
                            value: value, child: SizedBox(child: Text(value))))
                    .toList(),
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
