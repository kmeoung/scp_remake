
import 'package:flutter/material.dart';
import 'package:refactory_scp/json_object/search_user_obj.dart';

class ShowTeamDialogController extends ChangeNotifier{
  List<SearchUserObject> member = [];

  add(SearchUserObject member){
    this.member.add(member);
    notifyListeners();
  }

  remove(SearchUserObject member){
    this.member.remove(member);
    notifyListeners();
  }

  get(){
    return member;
  }
}