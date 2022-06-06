import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';

enum PROJECT_TYPE { MY, ANOTHER, ALL }

class HomeController extends ChangeNotifier {
  List<ProjectObject> myProjects = [];
  List<ProjectObject> anotherProjects = [];
  String userName = '';

  add(ProjectObject project, {required PROJECT_TYPE projectType}) {
    if (projectType == PROJECT_TYPE.MY) {
      myProjects.add(project);
    } else if (projectType == PROJECT_TYPE.ANOTHER) {
      anotherProjects.add(project);
    }
    notifyListeners();
  }

  setUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  List<ProjectObject> get({required PROJECT_TYPE projectType}) {
    if (projectType == PROJECT_TYPE.MY) {
      return myProjects;
    } else if (projectType == PROJECT_TYPE.ANOTHER) {
      return anotherProjects;
    } else if (projectType == PROJECT_TYPE.ALL) {
      List<ProjectObject> all = [];
      all.addAll(myProjects);
      all.addAll(anotherProjects);
      return all;
    }
    return myProjects;
  }

  clear({required PROJECT_TYPE projectType}) {
    if (projectType == PROJECT_TYPE.MY) {
      myProjects.clear();
    } else if (projectType == PROJECT_TYPE.ANOTHER) {
      anotherProjects.clear();
    } else {
      myProjects.clear();
      anotherProjects.clear();
    }
    notifyListeners();
  }
}
