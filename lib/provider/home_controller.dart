import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/home/home_project_obj.dart';

enum PROJECT_TYPE { MY, ANOTHER, ALL }

class HomeController extends ChangeNotifier {
  List<ProjectObject> myProjects = [];
  List<ProjectObject> anotherProjects = [];

  add(ProjectObject project, {required PROJECT_TYPE projectType}) {
    if (projectType == PROJECT_TYPE.MY) {
      myProjects.add(project);
    } else if (projectType == PROJECT_TYPE.ANOTHER) {
      anotherProjects.add(project);
    }
    notifyListeners();
  }

  List<ProjectObject> get({required PROJECT_TYPE projectType}) {
    if (projectType == PROJECT_TYPE.MY) {
      return myProjects;
    } else if (projectType == PROJECT_TYPE.ANOTHER) {
      return anotherProjects;
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
