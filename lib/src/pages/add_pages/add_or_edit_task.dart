import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:refactory_scp/http/file_http_client.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/search_project_member_obj.dart';
import 'package:refactory_scp/provider/add_task_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/components/search_team_member_dialog.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class AddOrEditTask extends DefaultTemplate {
  final String uid;
  final String pid;
  final String? tid;
  int requestUserId = -1;
  DateTime _dateTime = DateTime.now();

  AddOrEditTask({required this.uid, required this.pid, this.tid, Key? key})
      : super(uid, key: key);
  bool isEdit = false;

  final TextEditingController _contentController = TextEditingController();

  Widget customDetail(ScrollController controller, BuildContext context) {
    isEdit = tid != null;
    return ChangeNotifierProvider(
      create: (_) => AddTaskController(),
      builder: (context, child) {
        return Consumer<AddTaskController>(
          builder: (context, value, child) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContentTitle(
                    title: '${isEdit ? 'Edit' : 'Add'} Task',
                  ),
                  _contents(context, 'Input Contents', minHeight: 300),
                  const SizedBox(
                    height: 20,
                  ),
                  _addTeamMember(context, 'Select Team Member'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _selectFiles(context);
                      },
                      child: const Text(
                        'Add Files',
                        style: TextStyle(color: CustomColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: CustomColors.green)),
                  SingleChildScrollView(
                    child: Row(
                      children: List.generate(
                          context.watch<AddTaskController>().filePath.length,
                          (index) {
                        var path =
                            context.watch<AddTaskController>().filePath[index];
                        return Row(children: [
                          Text(path?? 'file$index',style:const TextStyle(color: Colors.black),),
                          const SizedBox(width: 10,),
                          IconButton(onPressed: () {
                            context.read<AddTaskController>().removeFilePath(context.read<AddTaskController>().filePath[index]??'file$index');
                          }, icon: const Icon(Icons.close,color: Colors.black,)),
                        ],);
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  context.watch<AddTaskController>().getUser() != null
                      ? _member(context,
                          context.watch<AddTaskController>().getUser()!)
                      : Container(),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectFiles(BuildContext context) async {
    List<String?>? filePaths = await FileHttpClient.selectFiles();

    if (filePaths != null) {
      context.read<AddTaskController>().setFilePath(filePaths);
    }
  }

  void _uploadFiles(List<String?> filePaths, int tid) {
    FileHttpClient.uploadFiles(
      pid: int.parse(pid),
      tid: tid,
      filePaths: filePaths,
      onSuccess: (Map<String, dynamic> json, String message) {
        Fluttertoast.showToast(
            msg: 'upload successed',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      onFailed: (String message) {
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      },
    );
  }

  /// add task
  _addTask(BuildContext context) async {
    var url = Comm_Params.URL_TASK_SEND;
    if (_contentController.value.text.isEmpty) {
      return;
    }
    if (requestUserId < 0) return;

    print('test log ' + pid);
    Map<String, dynamic> body = {
      "projectId": int.parse(pid),
      "userId": int.parse(uid),
      "projectinuserId": requestUserId,
      "taskContent": _contentController.value.text,
      "taskDeadline": DateFormat('yyyy-MM-dd HH:mm:ss').format(_dateTime),
    };
    ScpHttpClient.post(
      url,
      body: body,
      onSuccess: (json, message) {
        if (context.read<AddTaskController>().filePath.isNotEmpty) {
          int taskId = json["result"]["createdTask"]["taskId"];
          _uploadFiles(context.read<AddTaskController>().filePath, taskId);
        }
      },
      onFailed: (message) => ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
          SnackBar(
        content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
        duration: const Duration(seconds: 5), //올라와있는 시간
        action: SnackBarAction(
          //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
          label: 'close', //버튼이름
          onPressed: () {}, //버튼 눌렀을때.
        ),
      )),
    );
  }

  Widget _contents(BuildContext context, String title, {double minHeight = 0}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            color: Colors.white,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: title,
                    hintStyle: TextStyle(
                        color: CustomColors.deepPurple.withOpacity(0.5)),
                    label: null,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDatePickerPop(context);
          },
          child: Card(
            color: CustomColors.yellow,
            elevation: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text(
                DateFormat('yyyy-MM-dd')
                    .format(context.watch<AddTaskController>().getDateTime()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /* DatePicker 띄우기 */
  void showDatePickerPop(BuildContext context) {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //초기값
      firstDate: DateTime(2022),
      //시작일
      lastDate: DateTime(2024),
      //마지막일
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), //다크 테마
          child: child!,
        );
      },
    );

    selectedDate.then((dateTime) {
      _dateTime = DateTime.parse(dateTime.toString());
      context.read<AddTaskController>().changeDateTime(dateTime.toString());
    });
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
          SearchProjectMemberObject result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SearchTeamMemberDialog(
                width: size.width * 0.7,
                height: size.height * 0.5,
                pid: pid,
              );
            },
          );
          requestUserId = result.id;
          context.read<AddTaskController>().setUser(result);
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

  Widget _member(BuildContext context, SearchProjectMemberObject user) {
    List<String> _permissions = ['멤버'];

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
                      user.userNickname,
                      style: const TextStyle(
                          color: CustomColors.white, fontSize: 12),
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
                value: _permissions[0],
                elevation: 0,
                style: const TextStyle(
                    color: CustomColors.deepPurple, fontSize: 12),
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: CustomColors.deepPurple,
                ),
                underline: Container(),
                onChanged: (String? value) {},
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
        _addTask(context);
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
