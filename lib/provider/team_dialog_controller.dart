
import 'package:flutter/cupertino.dart';

import '../json_object/team/team_dialog_obj.dart';

class TeamDialogController extends ChangeNotifier{
  List<TeamDialogObject> teams = [];

  add(TeamDialogObject team){
    teams.add(team);
    notifyListeners();
  }

  remove(TeamDialogObject team){
    if(teams.contains(team)){
      teams.remove(team);
      notifyListeners();
    }
  }

  clear(){
    teams.clear();
    notifyListeners();
  }
}