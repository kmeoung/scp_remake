import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/components/content_title.dart';
import 'package:refactory_scp/src/pages/home/add_or_edit_task.dart';
import 'package:refactory_scp/src/pages/template/default_template.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatPage extends DefaultTemplate {
  final String uid;
  ChatPage({required this.uid, Key? key}) : super(uid, key: key);

  // void onConnect(StompFrame frame) {
  //   stompClient.subscribe(
  //     destination: '/topic/test/subscription',
  //     callback: (frame) {
  //       List<dynamic>? result = json.decode(frame.body!);
  //       print(result);
  //     },
  //   );
  //
  //   Timer.periodic(Duration(seconds: 10), (_) {
  //     stompClient.send(
  //       destination: '/app/test/endpoints',
  //       body: json.encode({'a': 123}),
  //     );
  //   });
  // }
  //
  // final stompClient = StompClient(
  //   config: StompConfig(
  //     url: 'ws://localhost:8080',
  //     onConnect: onConnect,
  //     beforeConnect: () async {
  //       print('waiting to connect...');
  //       await Future.delayed(Duration(milliseconds: 200));
  //       print('connecting...');
  //     },
  //     onWebSocketError: (dynamic error) => print(error.toString()),
  //     stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //     webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //   ),
  // );
  //
  // void main() {
  //   stompClient.activate();
  // }

  @override
  List<Widget> customDetail(BuildContext context) {
    return [
      ContentTitle(title: 'Chat', onTapMore: () {}),
      _headerTaskPerson(),
      const SizedBox(
        height: 10,
      ),
      _headerTaskContents(),
      const SizedBox(
        height: 30,
      ),
      ...List.generate(
        Random().nextInt(10),
        (index) => _commentView(),
      ),
      const SizedBox(
        height: 10,
      ),
      _inputCommentView(),
    ];
  }

  /// 담당자 Widget
  Widget _headerTaskPerson() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'name',
                  style: TextStyle(color: CustomColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Icon(
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
              children: const [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'name',
                  style: TextStyle(color: CustomColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerTaskContents() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 1,
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,',
                  overflow: TextOverflow.fade),
            ),
          ),
        ),
        Card(
          color: CustomColors.yellow,
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: const Text(
              'yyyy-MM-dd',
              style: TextStyle(
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
  Widget _commentView() {
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
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: CustomColors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'name',
                      style: TextStyle(color: CustomColors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    'yyyy-MM-dd\nHH:mm:ss',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Card(
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,',
                    overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCommentView() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          textInputAction: TextInputAction.newline,
          maxLines: null,
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
              onPressed: () {},
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
