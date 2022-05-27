import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/chat_room_obj.dart';
import 'package:refactory_scp/provider/chat_room_controller.dart';
import 'package:refactory_scp/provider/project_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/common/comm_param.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_project.dart';
import 'package:refactory_scp/src/pages/home/chat_page.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';

class TeamRoomPage extends DefaultTemplate {
  final String uid;

  TeamRoomPage({
    required this.uid,
    Key? key,
  }) : super(uid, key: key);

  /// Get chat room
  _getChatRoom(BuildContext context) async {
    var url = Comm_Params.URL_CHAT_ROOM.replaceAll(Comm_Params.USER_ID, uid);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ChatRoomController>().clear();
        List<dynamic> room = json['room'];
        if (room.isNotEmpty) {
          for (Map<String, dynamic> json in room) {
            ChatRoomObject room = ChatRoomObject.fromJson(json);
            context.read<ChatRoomController>().add(room);
          }
        }
      },
      onFailed: (message) {
        context.read<ChatRoomController>().clear();
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

  Widget customDetail(ScrollController controller, BuildContext context) {
    return ChangeNotifierProvider<ChatRoomController>(
      create: (_) => ChatRoomController(),
      builder: (context, child) {
        _getChatRoom(context);
        return Consumer<ChatRoomController>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContentTitle(
                      title: 'Chat Room',
                      onTapMore: () {},
                    ),
                    _contentView(context, 'Chat Room'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Binding View All My Content View
  Widget _contentView(BuildContext context, String title) {
    Size size = MediaQuery.of(context).size;
    List<ChatRoomObject> room = context.watch<ChatRoomController>().get();

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
            ...List.generate(
              room.length,
              (index) {
                ChatRoomObject chat = room[index];
                Color color = CustomColors.deepPurple;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: _roomCard(context, chat, color: color),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _roomCard(BuildContext context, ChatRoomObject chat,
      {required Color color}) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              uid: uid,
              chatRoomId: '${chat.chatroomId}',
            ),
          ),
        );
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
                  chat.chatroomName,
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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => AddOrEditTask(uid: uid, pid: pid)));
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
