import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/comment_obj.dart';
import 'package:refactory_scp/json_object/task_and_comment_obj.dart';
import 'package:refactory_scp/provider/task_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_task.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class TaskPage extends DefaultTemplate {
  final String uid;
  final String pid;
  final String tid;
  final String projectName;
  final taskComplete;
  TaskPage(
      {required this.projectName,
      required this.uid,
      required this.pid,
      required this.tid,
      required this.taskComplete,
      Key? key})
      : super(uid, key: key);

  BuildContext? getContext;

  /// Get Task Detail
  _getTaskDetail(BuildContext context) async {
    var url = Comm_Params.URL_TASK_DETAIL.replaceAll(Comm_Params.TASK_ID, tid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<TaskController>().clear();
        TaskAndCommentObject task =
            TaskAndCommentObject.fromJson(json['taskDetail']);
        context.read<TaskController>().task = task;

        for (Map<String, dynamic> comment in task.commentList) {
          context.read<TaskController>().add(CommentObject.fromJson(comment));
        }

        mainScrollController.animateTo(
            mainScrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 1),
            curve: Curves.linear);
      },
      onFailed: (message) {
        context.read<TaskController>().clear();
        ScaffoldMessenger.of(context).showSnackBar(
            //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
            SnackBar(
          content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
          duration: const Duration(seconds: 5), //올라와있는 시간
          action: SnackBarAction(
            //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
            label: 'close', //버튼이름
            onPressed: () {}, //버튼 눌렀을때.
          ),
        ));
      },
    );
  }

  /// Post Comment Add
  _postCommentAdd(BuildContext context, String comment) async {
    var url = Comm_Params.URL_COMMENT_ADD;
    if (context.read<TaskController>().task != null) {
      var task = context.read<TaskController>().task!;
      Map<String, dynamic> body = {
        "taskId": task.taskId,
        "userId": int.parse(uid),
        "commentContent": comment,
      };
      await ScpHttpClient.post(
        url,
        body: body,
        onSuccess: (json, message) {
          commentController.clear();
          _getTaskDetail(context);
        },
        onFailed: (message) {
          context.read<TaskController>().clear();
          ScaffoldMessenger.of(context).showSnackBar(
              //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
              SnackBar(
            content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
            duration: const Duration(seconds: 5), //올라와있는 시간
            action: SnackBarAction(
              //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
              label: 'close', //버튼이름
              onPressed: () {}, //버튼 눌렀을때.
            ),
          ));
        },
      );
    }
  }

  Widget customDetail(ScrollController controller, BuildContext context) {
    return ChangeNotifierProvider<TaskController>(
      create: (_) => TaskController(),
      builder: (context, child) {
        _getTaskDetail(context);
        return Consumer<TaskController>(
          builder: (context, value, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContentTitle(
                            title: projectName,
                            onTapMore: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddOrEditTask(
                                          uid: uid, pid: pid, tid: tid)));
                            },
                          ),
                          _headerTaskPerson(context),
                          const SizedBox(
                            height: 10,
                          ),
                          _headerTaskContents(context),
                          const SizedBox(
                            height: 30,
                          ),
                          ...List.generate(
                            context.watch<TaskController>().comments.length,
                            (index) => _commentView(
                                context.watch<TaskController>().comments[index],
                                context),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _inputCommentView(context),
              ],
            );
          },
        );
      },
    );
  }

  updateTaskSuccessed(BuildContext context) {
    var url = Comm_Params.URL_PROJECT_WETHER
        .replaceAll(Comm_Params.USER_ID, uid)
        .replaceAll(Comm_Params.TASK_ID, tid);

    ScpHttpClient.patch(
      url,
      onSuccess: (json, message) {
        // todo : 여기서 업데이트
        int isSuccessed = context.read<TaskController>().isSuccessed();
        context.read<TaskController>().setSuccessed(isSuccessed == 1 ? 0 : 1);
      },
      onFailed: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
            //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
            SnackBar(
          content: Text(message), //snack bar의 내용. icon, button같은것도 가능하다.
          duration: const Duration(seconds: 5), //올라와있는 시간
          action: SnackBarAction(
            //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
            label: 'close', //버튼이름
            onPressed: () {}, //버튼 눌렀을때.
          ),
        ));
      },
    );
  }

  /// 담당자 Widget
  Widget _headerTaskPerson(BuildContext context) {
    int isSuccessed = context.watch<TaskController>().isSuccessed();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            updateTaskSuccessed(context);
          },
          icon: Icon(
            (isSuccessed == 1) ? Icons.check_circle : Icons.circle_outlined,
            color: CustomColors.deepPurple,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
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
                Text(
                  context.watch<TaskController>().task != null
                      ? context.watch<TaskController>().task!.taskOwner_string
                      : '',
                  style:
                      const TextStyle(color: CustomColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const Icon(
          Icons.arrow_right_alt,
          color: CustomColors.deepPurple,
          size: 40,
        ),
        Container(
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
                Text(
                  context.watch<TaskController>().task != null
                      ? context
                          .watch<TaskController>()
                          .task!
                          .taskRequester_string
                      : '',
                  style:
                      const TextStyle(color: CustomColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerTaskContents(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  context.watch<TaskController>().task != null
                      ? context.watch<TaskController>().task!.taskContent
                      : '',
                  overflow: TextOverflow.fade),
            ),
          ),
        ),
        Card(
          color: CustomColors.yellow,
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              context.watch<TaskController>().task != null
                  ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                      context.watch<TaskController>().task!.taskDeadline))
                  : '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Comment View
  Widget _commentView(CommentObject comment, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: CustomColors.deepPurple.withOpacity(0.7),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
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
                      comment.commentNickname,
                      style: const TextStyle(
                          color: CustomColors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    comment.commentTime,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(comment.commentContent, overflow: TextOverflow.fade),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController commentController = TextEditingController();
  Widget _inputCommentView(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          maxLines: null,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            _postCommentAdd(context, commentController.text);
          },
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Input Comment',
            hintStyle:
                TextStyle(color: CustomColors.deepPurple.withOpacity(0.5)),
            label: null,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            suffixIcon: IconButton(
              splashRadius: 30,
              icon: const Icon(
                Icons.send,
                size: 25,
                color: Colors.blue,
              ),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  _postCommentAdd(context, commentController.text);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    return null;
  }

  @override
  void initSetting(BuildContext context) {
    // TODO: implement initSetting
  }
}
