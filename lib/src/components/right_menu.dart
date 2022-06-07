import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';
import 'package:refactory_scp/provider/home_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/profile_dialog.dart';
import 'package:refactory_scp/src/pages/home/home_page.dart';
import 'package:refactory_scp/src/pages/home/project_page.dart';

import 'package:refactory_scp/src/pages/team/team_page.dart';
import 'package:refactory_scp/src/pages/chat/chat_room_page.dart';


/// Desktop -> 오른쪽 메뉴
/// Mobile -> Drawer
class RightMenu extends StatefulWidget {
  double width;
  bool isMobile;
  final _userId;

  RightMenu(
    this._userId, {
    Key? key,
    this.width = 300,
    this.isMobile = false,
  }) : super(key: key);

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return _mobileLayout(context);
    } else {
      return _desktopLayout(context);
    }
  }

  /// Get Server
  _getData(BuildContext context) async {
    var url = Comm_Params.URL_HOME.replaceAll(Comm_Params.USER_ID, widget._userId);

    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<HomeController>().clear(projectType: PROJECT_TYPE.ALL);
        Map<String,dynamic> homeview = json['homeView'];
        context.read<HomeController>().setUserName(homeview['profileUsername']);
        List<dynamic> projects = homeview['projects'];
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

  Widget _sizeMenuDetail(BuildContext context, bool isDesktop) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<HomeController>(
        create: (_) => HomeController(),
        builder: (context, child) {
          _getData(context);
          return Consumer<HomeController>(builder: (context, value, child) {
            return Container(
              height: double.infinity,
              color: CustomColors.deepPurple,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  width: widget.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.isMobile) Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ProfileDialog(
                                width: size.width * 0.5,
                                height: size.height * 0.5,
                                isDesktop: isDesktop,
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children:  [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: CustomColors.white,
                            ),
                            Expanded(
                              child: Padding(
                                padding:const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  context.watch<HomeController>().userName,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: CustomColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: CustomColors.white,
                        thickness: 1,
                        height: 40,
                      ),
                      const Text(
                        'BigMenu',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: CustomColors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _sideMenu(context, 'Home', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(
                              uid: widget._userId,
                            ),
                          ),
                        );
                      }),
                      _sideMenu(context, 'Team', onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TeamPage(
                                      uid: widget._userId,
                                    )));
                      }),
                      _sideMenu(context, 'Chat', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomPage(
                              uid: widget._userId,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Projects',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: CustomColors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ...List.generate(
                          context
                              .watch<HomeController>()
                              .get(projectType: PROJECT_TYPE.ALL)
                              .length, (index) {
                        ProjectObject proObj = context
                            .watch<HomeController>()
                            .get(projectType: PROJECT_TYPE.ALL)[index];

                        return _sideMenu(
                          context,
                          proObj.projectName,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProjectPage(
                                  projectName: proObj.projectName,
                                  pid: '${proObj.projectId}',
                                  uid: widget._userId,
                                  project: proObj,
                                  pageType: PROJECT_PAGE_TYPE.ALL,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget _mobileLayout(BuildContext context) {
    return _sizeMenuDetail(context, false);
  }

  Widget _desktopLayout(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: _sizeMenuDetail(context, true));
  }

  /// 사이드 메뉴
  Widget _sideMenu(BuildContext context, String title,
      {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          // 모바일 타입일 때 Drawer 종료 후 이동
          if (widget.isMobile) Navigator.pop(context);
          onPressed();
        }
      },
      style: ButtonStyle(
          alignment: Alignment.centerLeft,
          foregroundColor:
              MaterialStateProperty.resolveWith(getForegroundColor),
          overlayColor:
              MaterialStateProperty.resolveWith((state) => Colors.transparent),
          padding: MaterialStateProperty.resolveWith(getPadding)),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  /// Drawer 버튼 색상
  Color getForegroundColor(Set<MaterialState> states) {
    const interactiveStates = <MaterialState>{
      MaterialState.hovered,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return CustomColors.purple;
    }
    return CustomColors.white;
  }

  /// Drawer 버튼 이벤트
  EdgeInsets getPadding(Set<MaterialState> states) {
    const interactiveStates = <MaterialState>{
      MaterialState.hovered,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return const EdgeInsets.only(left: 5);
    }
    return EdgeInsets.zero;
  }
}
