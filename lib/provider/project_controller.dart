import 'package:flutter/cupertino.dart';
import 'package:refactory_scp/json_object/task_detail_obj.dart';

class ProjectController extends ChangeNotifier {
  List<TaskDetailObject> tasks = [];

  add(TaskDetailObject task) {
    tasks.add(task);
    notifyListeners();
  }

  clear() {
    tasks.clear();
    notifyListeners();
  }

  chageComplete(int index) {
    int currentComplete = tasks[index].taskComplete;
    tasks[index].taskComplete = currentComplete == 1 ? 0 : 1;
    notifyListeners();
  }
}
