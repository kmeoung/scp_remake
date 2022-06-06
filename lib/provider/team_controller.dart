import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/team_obj.dart';

enum TEAM_TYPE { MY, ANOTHER, ALL }

class TeamController extends ChangeNotifier {
  List<TeamObject> myTeam = [];
  List<TeamObject> anotherTeam = [];

  add(TeamObject team, {required TEAM_TYPE teamType}) {
    if (teamType == TEAM_TYPE.MY) {
      myTeam.add(team);
    } else if (teamType == TEAM_TYPE.ANOTHER) {
      anotherTeam.add(team);
    }
    notifyListeners();
  }

  List<TeamObject> get({required TEAM_TYPE teamType}) {
    if (teamType == TEAM_TYPE.MY) {
      return myTeam;
    } else if (teamType == TEAM_TYPE.ANOTHER) {
      return anotherTeam;
    }
    return myTeam;
  }

  clear({required TEAM_TYPE teamType}) {
    if (teamType == TEAM_TYPE.MY) {
      myTeam.clear();
    } else if (teamType == TEAM_TYPE.ANOTHER) {
      anotherTeam.clear();
    } else {
      myTeam.clear();
      anotherTeam.clear();
    }
    notifyListeners();
  }
}
