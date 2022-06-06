import 'package:flutter/cupertino.dart';
import 'package:refactory_scp/json_object/comment_obj.dart';
import 'package:refactory_scp/json_object/task_and_comment_obj.dart';
import 'package:refactory_scp/json_object/task_detail_obj.dart';

class TaskController extends ChangeNotifier {
  TaskAndCommentObject? task;
  List<CommentObject> comments = [];
  int _taskSuccessed = 0;



  add(CommentObject comment) {
    comments.add(comment);
    notifyListeners();
  }

  clear() {
    comments.clear();
    notifyListeners();
  }

  int isSuccessed() {
    return _taskSuccessed;
  }

  setSuccessed(int success) {
    _taskSuccessed = success;
    notifyListeners();
  }
}
