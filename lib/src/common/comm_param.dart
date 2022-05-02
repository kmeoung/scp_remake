class Comm_Params {
  static const USER_ID = ':userid';
  static const PROJECT_ID = ':projectid';
  static const PROJECT_IN_USER_ID = ':projectinuserId';
  // ??? 뭔지도 모름
  static const SELECTED = ':selected';
  static const _base = '/';
  static const _project = _base + 'project/';
  // 홈
  static const URL_HOME = _base + 'homeview' + '/$USER_ID';
  // 프로젝트 추가 {POST}
  static const URL_PROJECT_ADD = _project + 'createproject';
  // 전체 할 일 {GET}
  static const _allTask = _base + 'alltask/';
  static const URL_RPOJECT_ALL = _allTask + PROJECT_ID;
  // 내 할 일 {GET}
  static const _myTask = _base + 'mytask/';
  static const URL_PROJECT_MY = _myTask + USER_ID + '/' + PROJECT_ID;
  // 할 일 여부? {Patch}
  static const _wetherTask = _base + 'whethertask/';
  static const URL_PROJECT_WETHER = _wetherTask + USER_ID + '/' + PROJECT_ID;
  // 받은 할 일 {GET}
  static const _receiveTask = _base + 'receivetask/';
  static const URL_PROJECT_RECEIVE =
      _receiveTask + PROJECT_ID + '/' + PROJECT_IN_USER_ID;

  // 받은 할 일?? 이건 뭔지도 모르겠음 {PATH}

}
