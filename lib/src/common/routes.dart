/// Project All Url Routes
class AllRoutes {
  static const String PID = 'pid';
  static const String TID = 'tid';
  static const String TEAMID = 'teamid';
  static const String USERID = 'userid';

  static const String ARGS_PID = ':' + PID;
  static const String ARGS_TID = ':' + TID;
  static const String ARGS_TEAMID = ':' + TEAMID;
  static const String ARGS_USERID = ':' + USERID;

  static const String INITROUTE = '/';
  static const String LOGIN = INITROUTE + 'login';
  static const String HOME = '/' + ARGS_USERID + '/';

  static const String TEAM = HOME + 'team';
  static const String _team = TEAM + '/$ARGS_TEAMID';
  static const String TEAM_DETAIL = _team;
  static const String TEAM_EDIT = _team + '/edit';
  static const String TEAM_ADD = TEAM + '/add';
  static const String _project = HOME + 'project';
  static const String PROJECT_ADD = _project + '/add';
  static const String _projectDetail = _project + '/' + ARGS_PID;
  static const String PROJECT_ALL = _projectDetail + '/all';
  static const String PROJECT_MY = _projectDetail + '/my';
  static const String PROJECT_RECEIVETASK = _projectDetail + '/receiveTask';
  static const String PROJECT_SENDTASK = _projectDetail + '/sendTask';
  static const String PROJECT_EDIT = _projectDetail + '/edit';

  static const String _task = _projectDetail + '/task';
  static const String TASK = _task + '/' + ARGS_TID;
  static const String TASK_ADD = _task + '/new/add';
  static const String TASK_EDIT = TASK + '/edit';
}
