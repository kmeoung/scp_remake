import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';

class TeamSearchController extends ChangeNotifier {
  List<SearchUserObject> users = [];

  add(SearchUserObject user) {
    users.add(user);
    notifyListeners();
  }

  List<SearchUserObject> get() {
    return users;
  }

  clear() {
    users.clear();
    notifyListeners();
  }
}
