class Comm_Params {
  static const USER_ID = ':userid';
  static const TEAM_ID = ':teamid';
  static const PROJECT_ID = ':projectid';
  static const TASK_ID = ':taskid';
  static const PROJECT_IN_USER_ID = ':projectinuserId';
  static const EMAIL_KEYWORD = ':email_keyword';
  static const CHAT_ROOM_ID = ':chat_room_id';
  static const COMMENDID = ':COMMENDID';
  // ??? 뭔지도 모름
  static const SELECTED = ':selected';
  static const _base = '/';
  static const _project = _base + 'project/';
  // 홈
  static const URL_HOME = _base + 'homeview' + '/$USER_ID';
  // 프로젝트 추가 {POST}
  static const URL_PROJECT_ADD = _base + 'createproject';
  // 전체 할 일 {GET}
  static const _allTask = _base + 'alltask/';
  static const URL_RPOJECT_ALL = _allTask + PROJECT_ID;
  // 내 할 일 {GET}
  static const _myTask = _base + 'mytask/';
  static const URL_PROJECT_MY = _myTask + USER_ID + '/' + PROJECT_ID;
  // 할 일 여부? {Patch}
  static const _wetherTask = _base + 'whethertask/';
  static const URL_PROJECT_WETHER = _wetherTask + USER_ID + '/' + TASK_ID;

  static const _receiveTask = _base + 'receivetask/';
  // 받은 할 일 (수락/거절) {PATCH}
  static const URL_TASK_ACCEPT_REFUSE = _receiveTask + TASK_ID + '/' + SELECTED;
  // 받은 할 일 {GET}
  static const URL_PROJECT_RECEIVE = _receiveTask + PROJECT_ID + '/' + USER_ID;

  static const _requestTask = _base + 'requestask/';
  // 보낸 할 일 {GET}
  static const URL_PROJECT_REQUEST = _requestTask + PROJECT_ID + '/' + USER_ID;

  // post task 추가 {POST}
  static const URL_TASK_SEND = _base + 'sendtask/';
  // project 내의 user 조회 {GET}
  static const URL_PROJECT_MEMBER = URL_TASK_SEND + PROJECT_ID;

  static const _taskDetail = _base + 'taskDetail/';
  // 할 일 상세 {GET}
  static const URL_TASK_DETAIL = _taskDetail + TASK_ID;
  // 댓글 작성 추가 {POST}
  static const URL_COMMENT_ADD = _base + 'commentwrite/';
  // 댓글 수정
  static const URL_COMMENT_EDIT = _base + 'commentmodify/$COMMENDID';
  // 댓글 삭제
  static const URL_COMMENT_DELETE = _base + 'commentdelete/$COMMENDID';

  static const _team = _base + 'team/';
  static const _team_home = _team + 'home/';
  // 팀 조회 {GET}
  static const URL_TEAM = _team_home + USER_ID;
  // 팀 조회
  static const URL_TEAM_LIST = _team + 'getUserTeamList/$USER_ID';
  // 팀 원 조회
  static const URL_TEAM_MEMBER_LIST = _team + 'getTeamMembers/$TEAM_ID';
  // 팀원 조회 {GET}
  static const URL_SEARCH_USER =
      _team + 'getUsersByEmail/' + USER_ID + '/' + EMAIL_KEYWORD;

  static const _chat = _base + 'chat/';
  // 채팅 내역 조회 {GET}
  static const URL_CHAT = _chat + CHAT_ROOM_ID;
  // 채팅방 조회 {GET}
  static const URL_CHAT_ROOM = _base + 'lookupRoom/' + USER_ID;
}
