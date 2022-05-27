import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/chat_room_obj.dart';

class ChatRoomController extends ChangeNotifier {
  List<ChatRoomObject> _list = [];

  add(ChatRoomObject value) {
    _list.add(value);
    notifyListeners();
  }

  List<ChatRoomObject> get() {
    return _list;
  }

  clear() {
    _list.clear();
    notifyListeners();
  }
}
