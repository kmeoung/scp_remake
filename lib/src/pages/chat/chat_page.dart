import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/http/scp_http_client.dart';
import 'package:refactory_scp/json_object/chat/chat_obj.dart';
import 'package:refactory_scp/provider/chat/chat_controller.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:refactory_scp/src/common/comm_param.dart';

class ChatPage extends DefaultTemplate {
  final String uid;
  final String chatRoomId;

  StompClient? stompClient;

  ChatPage({required this.uid, required this.chatRoomId, Key? key})
      : super(uid, key: key);

  final socketUrl = 'ws://mmgg.kr/chat';

  sendMessage({required String msg}) {
    String token = 'Bearer ${ScpHttpClient.TOKEN}';
    var headers = {'Authorization': token};
    stompClient!.send(destination: '/app/$chatRoomId/$uid',headers:headers, body: msg);
  }

  /// Get Chat comment
  _getData(BuildContext context) async {
    var url =
    Comm_Params.URL_CHAT.replaceAll(Comm_Params.CHAT_ROOM_ID, chatRoomId);
    await ScpHttpClient.get(
      url,
      onSuccess: (json, message) {
        context.read<ChatController>().clear();
        Map<String, dynamic> message = json['messages'];
        List<dynamic> msgList = message['messageList'];

        if (msgList.isNotEmpty) {
          for (Map<String, dynamic> json in msgList) {
            ChatObject obj = ChatObject.fromJson(json);

            context.read<ChatController>().add(obj);
          }

          mainScrollController.animateTo(
              mainScrollController.position.maxScrollExtent + 100,
              duration: const Duration(milliseconds: 1),
              curve: Curves.linear);
        }
      },
      onFailed: (message) {
        context.read<ChatController>().clear();
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

  connectStomp(BuildContext context) async {
    String token = 'Bearer ${ScpHttpClient.TOKEN}';
    var headers = {'Authorization': token};
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig(
            url: socketUrl,stompConnectHeaders: headers,
            onConnect: (frame) {
              stompClient!.subscribe(
                headers: headers,
                destination: '/topic/$chatRoomId',
                callback: (StompFrame frame) {
                  print(frame.body);
                  if (frame.body != null) {
                    Map<String, dynamic> obj = json.decode(frame.body!);
                    var chat = ChatObject.fromJson(obj);
                    context.read<ChatController>().add(chat);
                    mainScrollController.animateTo(
                        mainScrollController.position.maxScrollExtent + 100,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.linear);
                  }
                },
              );
            },
            onStompError: (StompFrame) => print(StompFrame),
            onWebSocketError: (e) => print('webSocket err : $e'),
          ));
      stompClient!.activate();
    } else {
      stompClient!.deactivate();
    }
  }

  Widget customDetail(ScrollController scrollController, BuildContext context) {
    return ChangeNotifierProvider<ChatController>(
      create: (_) => ChatController(),
      builder: (context, child) {
        connectStomp(context);
        _getData(context);
        return Consumer<ChatController>(
          builder: (context, value, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ContentTitle(title: 'Chat', onTapMore: null),
                          const SizedBox(
                            height: 30,
                          ),
                          ...List.generate(
                            context.watch<ChatController>().get().length,
                                (index) => _commentView(
                                context.watch<ChatController>().get()[index]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _sendMessage(context),
              ],
            );
          },
        );
      },
    );
  }

  /// Comment View
  Widget _commentView(ChatObject chat) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (chat.userId.toString() == uid) Expanded(child: Container()),
        Column(
          crossAxisAlignment: chat.userId.toString() == uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.purple,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  chat.userNickname,
                  style:
                  const TextStyle(color: CustomColors.yellow, fontSize: 12),
                ),
              ],
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(chat.messageContent, overflow: TextOverflow.fade),
              ),
            ),
            Text(
              chat.messageTime,
              style: const TextStyle(color: CustomColors.yellow, fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        if (chat.userId.toString() != uid) Expanded(child: Container()),
      ],
    );
  }

  TextEditingController commentController = TextEditingController();

  Widget _sendMessage(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (commentController.text.isNotEmpty) {
              sendMessage(msg: commentController.text);
              commentController.clear();
            }
          },
          maxLines: null,
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
                  sendMessage(msg: commentController.text);
                  commentController.clear();
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
    // TODO: implement floatingActionButton
    return null;
  }

  @override
  void initSetting(BuildContext context) {
    // TODO: implement initSetting
  }
}
