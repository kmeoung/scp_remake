import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/task_detail_obj.dart';
import 'package:refactory_scp/provider/project_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_project.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_task.dart';
import 'package:refactory_scp/src/pages/home/task_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

enum PROJECT_PAGE_TYPE { ALL, MY, RECEIVE, SEND }

class ProjectPage extends DefaultTemplate {
  PROJECT_PAGE_TYPE pageType;
  final String pid;
  final String uid;
  final String projectName;

  ProjectPage(
      {required this.projectName,
      required this.pid,
      required this.uid,
      Key? key,
      required this.pageType})
      : super(uid, key: key);

  final String ALL_TASK = 'ALL Task';
  final String MY_TASK = 'MY Task';
  final String RECEIVE_TASK = 'RECEIVE Task';
  final String SEND_TASK = 'SEND Task';

  /// Get All Task
  _getAllTask(BuildContext context) async {
    var url =
        Comm_Params.URL_RPOJECT_ALL.replaceAll(Comm_Params.PROJECT_ID, pid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ProjectController>().clear();
        List<dynamic> tasks = json['tasklist'];
        if (tasks.isNotEmpty) {
          for (Map<String, dynamic> json in tasks) {
            TaskDetailObject task = TaskDetailObject.fromJson(json);
            context.read<ProjectController>().add(task);
          }
        }
      },
      onFailed: (message) {
        context.read<ProjectController>().clear();
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

  /// Get All Task
  _getMyTask(BuildContext context) async {
    var url = Comm_Params.URL_PROJECT_MY
        .replaceAll(Comm_Params.PROJECT_ID, pid)
        .replaceAll(Comm_Params.USER_ID, uid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ProjectController>().clear();
        List<dynamic> tasks = json['tasklist'];
        if (tasks.isNotEmpty) {
          for (Map<String, dynamic> json in tasks) {
            TaskDetailObject task = TaskDetailObject.fromJson(json);
            context.read<ProjectController>().add(task);
          }
        }
      },
      onFailed: (message) {
        context.read<ProjectController>().clear();
        // Get.snackbar('Server Error', message,
        //     snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  /// Get Receive Task
  _getReceiveTask(BuildContext context) async {
    var url = Comm_Params.URL_PROJECT_RECEIVE
        .replaceAll(Comm_Params.PROJECT_ID, pid)
        .replaceAll(Comm_Params.USER_ID, uid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ProjectController>().clear();
        List<dynamic> tasks = json['tasklist'];
        if (tasks.isNotEmpty) {
          for (Map<String, dynamic> json in tasks) {
            TaskDetailObject task = TaskDetailObject.fromJson(json);
            context.read<ProjectController>().add(task);
          }
        }
      },
      onFailed: (message) {
        context.read<ProjectController>().clear();
        // Get.snackbar('Server Error', message,
        //     snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  /// Get Request Task
  _getRequestTask(BuildContext context) async {
    var url = Comm_Params.URL_PROJECT_REQUEST
        .replaceAll(Comm_Params.PROJECT_ID, pid)
        .replaceAll(Comm_Params.USER_ID, uid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ProjectController>().clear();
        List<dynamic> tasks = json['tasklist'];
        if (tasks.isNotEmpty) {
          for (Map<String, dynamic> json in tasks) {
            TaskDetailObject task = TaskDetailObject.fromJson(json);
            context.read<ProjectController>().add(task);
          }
        }
      },
      onFailed: (message) {
        context.read<ProjectController>().clear();
        // Get.snackbar('Server Error', message,
        //     snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  @override
  List<Widget> customDetail(BuildContext context) {
    return [
      ChangeNotifierProvider<ProjectController>(
        create: (_) => ProjectController(),
        builder: (context, child) {
          String projectSubTitle;
          switch (pageType) {
            case PROJECT_PAGE_TYPE.ALL:
              projectSubTitle = ALL_TASK;
              _getAllTask(context);
              break;
            case PROJECT_PAGE_TYPE.MY:
              projectSubTitle = MY_TASK;
              _getMyTask(context);
              break;
            case PROJECT_PAGE_TYPE.RECEIVE:
              projectSubTitle = RECEIVE_TASK;
              _getReceiveTask(context);
              break;
            case PROJECT_PAGE_TYPE.SEND:
              projectSubTitle = SEND_TASK;
              _getRequestTask(context);
              break;
          }
          return Consumer<ProjectController>(
            builder: (context, value, child) => Column(children: [
              ContentTitle(
                title: projectName,
                onTapMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddOrEditProject(
                        uid: uid,
                        pid: pid,
                      ),
                    ),
                  );
                },
              ),
              _header(context),
              const SizedBox(
                height: 20,
              ),
              pageType == PROJECT_PAGE_TYPE.ALL ||
                      pageType == PROJECT_PAGE_TYPE.MY
                  ? _allMyContentView(context, projectSubTitle)
                  : _receiveSendContentView(context, pageType)
            ]),
          );
        },
      )
    ];
  }

  Widget _headerTitle(BuildContext context,
      {required PROJECT_PAGE_TYPE headerType}) {
    String bigTitle;
    String smallTitle;
    switch (headerType) {
      case PROJECT_PAGE_TYPE.ALL:
        bigTitle = 'All Task';
        smallTitle = 'ALL';
        break;
      case PROJECT_PAGE_TYPE.MY:
        bigTitle = 'My Task';
        smallTitle = 'MY';
        break;
      case PROJECT_PAGE_TYPE.RECEIVE:
        bigTitle = 'Receive Task';
        smallTitle = 'RECEIVE';
        break;
      case PROJECT_PAGE_TYPE.SEND:
        bigTitle = 'Send Task';
        smallTitle = 'SEND';
        break;
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectPage(
                projectName: projectName,
                pid: pid,
                uid: uid,
                pageType: headerType,
              ),
            ),
          );
        },
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.deepPurple, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            color: headerType == pageType
                ? CustomColors.deepPurple
                : CustomColors.white,
          ),
          child: Text(
            isMobile ? smallTitle : bigTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: headerType == pageType
                  ? CustomColors.white
                  : CustomColors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  /// Binding View Header
  Widget _header(BuildContext context) {
    return Row(
      children: [
        _headerTitle(context, headerType: PROJECT_PAGE_TYPE.ALL),
        const SizedBox(
          width: 20,
        ),
        _headerTitle(context, headerType: PROJECT_PAGE_TYPE.MY),
        const SizedBox(
          width: 20,
        ),
        _headerTitle(context, headerType: PROJECT_PAGE_TYPE.RECEIVE),
        const SizedBox(
          width: 20,
        ),
        _headerTitle(context, headerType: PROJECT_PAGE_TYPE.SEND),
      ],
    );
  }

  /// Binding View All My Content View
  Widget _allMyContentView(BuildContext context, String title) {
    Size size = MediaQuery.of(context).size;
    List<TaskDetailObject> tasks = context.watch<ProjectController>().tasks;
    var completeTask = tasks.where((task) => task.taskComplete == 1).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height * 0.7),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.deepPurple,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 30,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 9.0),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: LinearProgressIndicator(
                value: (completeTask.isNotEmpty)
                    ? tasks.length / completeTask.length * 0.1
                    : 0,
                backgroundColor: CustomColors.deepPurple,
                color: CustomColors.yellow,
                minHeight: 10,
              ),
            ),
            ...List.generate(
              tasks.length,
              (index) {
                TaskDetailObject task = tasks[index];
                Color color = CustomColors.deepPurple;

                switch (task.taskComplete) {
                  case 0: // 완료하지 않은 할 일
                    color = CustomColors.deepPurple;
                    break;
                  case 1: // 완료한 할 일
                    color = CustomColors.yellow;
                    break;
                }

                DateTime now = DateTime.now();
                DateTime deadLine = DateTime.parse(task.taskDeadline);
                // 데드라인이 얼마 안 남았을 경우와 넘겼을 경우
                if (deadLine.year >= now.year) {
                  if (deadLine.month >= now.month) {
                    if (deadLine.day >= now.day) {
                      if (deadLine.hour >= now.hour) {
                        color = CustomColors.gray;
                      }
                    }
                  }
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: _taskCard(context, task.taskId,
                      title: task.taskContent, color: color),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Receive Request Content view
  Widget _receiveSendContentView(
      BuildContext context, PROJECT_PAGE_TYPE pageType) {
    List<TaskDetailObject> tasks = context.watch<ProjectController>().tasks;
    return Column(
      children: List.generate(
          tasks.length, (index) => _receiveRequestCard(tasks[index], pageType)),
    );
  }

  // Receive Request Card Widget
  Widget _receiveRequestCard(
          TaskDetailObject task, PROJECT_PAGE_TYPE pageType) =>
      Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        color: CustomColors.deepPurple.withOpacity(0.7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: pageType == PROJECT_PAGE_TYPE.RECEIVE
                        ? CustomColors.yellow
                        : CustomColors.green,
                    child: Icon(
                      pageType == PROJECT_PAGE_TYPE.RECEIVE
                          ? Icons.arrow_back
                          : Icons.arrow_forward,
                      size: 15,
                      color: CustomColors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    task.taskOwner_string,
                    style: const TextStyle(
                        color: CustomColors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 5.0,
              color: CustomColors.white,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Text(task.taskContent),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: _taskRequestBtn(
                      title: 'Accept',
                      color: CustomColors.whitePurple,
                      onTap: () {}),
                ),
                Expanded(
                  child: _taskRequestBtn(
                      title: 'Cancel',
                      color: CustomColors.yellow,
                      onTap: () {}),
                ),
              ],
            )
          ],
        ),
      );

  Widget _taskRequestBtn(
      {String title = '', Color? color, GestureTapCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.white, fontSize: 15),
          ),
        ),
      ),
      color: color,
    );
  }

  Widget _taskCard(BuildContext context, int tid,
      {required String title, required Color color}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TaskPage(
                    projectName: projectName,
                    uid: uid,
                    pid: pid,
                    tid: '$tid')));
      },
      child: Card(
        elevation: 5.0,
        color: color.withOpacity(0.7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                radius: 15,
                backgroundColor: CustomColors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddOrEditTask(uid: uid, pid: pid)));
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
}
