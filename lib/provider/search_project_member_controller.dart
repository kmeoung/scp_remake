import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/search_project_member_obj.dart';

class SearchProjectMemeberController extends ChangeNotifier {
  List<SearchProjectMemberObject> _users = [];

  add(SearchProjectMemberObject member) {
    _users.add(member);
    notifyListeners();
  }

  List<SearchProjectMemberObject> get() {
    return _users;
  }

  clear() {
    _users.clear();
    notifyListeners();
  }
}
