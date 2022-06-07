import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/chat/chat_obj.dart';

class ChatController extends ChangeNotifier {
  List<ChatObject> chats = [];
  add(ChatObject chat) {
    chats.add(chat);
    notifyListeners();
  }

  List<ChatObject> get() {
    return chats;
  }

  clear() {
    chats.clear();
    notifyListeners();
  }
}
