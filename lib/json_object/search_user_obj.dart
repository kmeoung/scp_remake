class SearchUserObject {
  final int userId;
  final String userNickname;
  final String userEmail;

  factory SearchUserObject.fromJson(Map<String, dynamic> json) {
    return SearchUserObject(
      json['userId'],
      json['userNickname'],
      json['userEmail'],
    );
  }

  SearchUserObject(this.userId, this.userNickname, this.userEmail);
}
