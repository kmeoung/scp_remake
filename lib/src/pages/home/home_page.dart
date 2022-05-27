import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';
import 'package:refactory_scp/json_object/task_obj.dart';
import 'package:refactory_scp/provider/home_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_project.dart';
import 'package:refactory_scp/src/pages/home/project_page.dart';
import 'package:refactory_scp/src/pages/home/task_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class HomePage extends DefaultTemplate {
  final String _userId;
  HomePage({required String uid, Key? key})
      : _userId = uid,
        super(uid, key: key);

  Widget customDetail(ScrollController controller, BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(),
      builder: (context, child) {
        _getData(context);
        return Consumer<HomeController>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContentTitle(title: 'My Project'),
                    _homeItemView(
                        projects: context
                            .watch<HomeController>()
                            .get(projectType: PROJECT_TYPE.MY)),
                    const SizedBox(
                      height: 40,
                    ),
                    ContentTitle(title: 'Shared Project'),
                    _homeItemView(
                        projects: context
                            .watch<HomeController>()
                            .get(projectType: PROJECT_TYPE.ANOTHER)),
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
  _getData(BuildContext context) async {
    var url = Comm_Params.URL_HOME.replaceAll(Comm_Params.USER_ID, _userId);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<HomeController>().clear(projectType: PROJECT_TYPE.ALL);
        List<dynamic> projects = json['projects'];
        if (projects.isNotEmpty) {
          for (Map<String, dynamic> json in projects) {
            ProjectObject obj = ProjectObject.fromJson(json);
            if (obj.userCode == IS_HAVE.leader) {
              context.read<HomeController>().add(
                    obj,
                    projectType: PROJECT_TYPE.MY,
                  );
            } else {
              context.read<HomeController>().add(
                    obj,
                    projectType: PROJECT_TYPE.ANOTHER,
                  );
            }
          }
        }
      },
      onFailed: (message) {
        context.read<HomeController>().clear(projectType: PROJECT_TYPE.ALL);
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

  /// View Binding Home Item View
  Widget _homeItemView({required List<ProjectObject> projects}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 5,
        childAspectRatio: 9 / 10,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) => _projectCard(context, projects[index]),
    );
  }

  /// View Binding Project Card
  Widget _projectCard(BuildContext context, ProjectObject project) {
    var isMine = project.userCode == IS_HAVE.leader;
    int taskSize = project.tasklist.length;
    int successTasks = project.tasklist.where((element) {
      var taskObject = TaskObject.fromJson(element);
      return taskObject.taskComplete == 1;
    }).length;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectPage(
              projectName: project.projectName,
              pid: '${project.projectId}',
              uid: _userId,
              project: project,
              pageType: PROJECT_PAGE_TYPE.ALL,
            ),
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        project.projectName,
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
                                builder: (_) => AddOrEditProject(
                                  uid: _userId,
                                  project: project,
                                ),
                              ));
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
                  children: List.generate(
                    (project.tasklist.length > 3)
                        ? 3
                        : project.tasklist.isEmpty
                            ? 1
                            : project.tasklist.length,
                    (index) {
                      if (project.tasklist.isEmpty) {
                        return Expanded(
                          child: _taskCard(context, project.projectId, -1,
                              projectTitle: project.projectName,
                              isComplete: 0,
                              project: project,
                              title: '할 일을 추가해 주세요.',
                              color: CustomColors.gray),
                        );
                      } else {
                        TaskObject task = TaskObject.fromJson(
                            project.tasklist[index] as Map<String, dynamic>);

                        var color = CustomColors.deepPurple;
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

                        return Expanded(
                          child: _taskCard(
                              context, project.projectId, task.taskId,
                              projectTitle: project.projectName,
                              isComplete: task.taskComplete,
                              title: task.taskContent,
                              project: project,
                              color: color),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 30,
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 9.0),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: LinearProgressIndicator(
                value: project.tasklist.isEmpty
                    ? 0
                    : (successTasks > 0)
                        ? taskSize / successTasks * 0.1
                        : 0,
                backgroundColor: CustomColors.white,
                color: CustomColors.yellow,
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// View Binding Task Card
  Widget _taskCard(BuildContext context, int pid, int tid,
      {required String projectTitle,
      required int isComplete,
      required ProjectObject project,
      required String title,
      required Color color}) {
    return InkWell(
      onTap: () {
        if (tid > -1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskPage(
                taskComplete: isComplete,
                projectName: projectTitle,
                uid: _userId,
                pid: '$pid',
                tid: '$tid',
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectPage(
                projectName: title,
                uid: _userId,
                pid: '$pid',
                project: project,
                pageType: PROJECT_PAGE_TYPE.ALL,
              ),
            ),
          );
        }
      },
      child: Card(
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
                  textAlign: tid > -1 ? TextAlign.start : TextAlign.center,
                ),
              ),
              Visibility(
                visible: tid > -1,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.white,
                ),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => AddOrEditProject(uid: _userId)));
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
