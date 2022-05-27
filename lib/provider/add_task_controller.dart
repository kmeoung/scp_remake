import 'package:flutter/cupertino.dart';
import 'package:refactory_scp/json_object/search_project_member_obj.dart';

class AddTaskController extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  SearchProjectMemberObject? _selectUser;

  setUser(SearchProjectMemberObject user) {
    _selectUser = user;
    notifyListeners();
  }

  SearchProjectMemberObject? getUser() {
    return _selectUser;
  }

  changeDateTime(String value) {
    _dateTime = DateTime.parse(value);
    notifyListeners();
  }

  DateTime getDateTime() {
    return _dateTime;
  }
}
