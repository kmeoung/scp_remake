class Comm_Params {
  static const USER_ID = ':userid';
  static const PROJECT_ID = ':projectid';
  static const TASK_ID = ':taskid';
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

  static const _receiveTask = _base + 'receivetask/';
  // 받은 할 일 (수락/거절) {PATCH}
  static const URL_TASK_ACCEPT_REFUSE = _receiveTask + TASK_ID + '/' + SELECTED;
  // 받은 할 일 {GET}
  static const URL_PROJECT_RECEIVE = _receiveTask + PROJECT_ID + '/' + USER_ID;

  static const _requestTask = _base + 'requestask/';
  // 보낸 할 일 {GET}
  static const URL_PROJECT_REQUEST = _requestTask + PROJECT_ID + '/' + USER_ID;

  static const _taskDetail = _base + 'taskDetail/';
  // 할 일 상세 {GET}
  static const URL_TASK_DETAIL = _taskDetail + TASK_ID;
  // 댓글 작성 추가 {POST}
  static const URL_COMMENT_ADD = _base + 'commentwrite/';
}
