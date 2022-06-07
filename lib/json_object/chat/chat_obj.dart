class ChatObject {
  final int userId;
  final String userNickname;
  final String messageContent;
  final String messageTime;

  ChatObject(
      this.userId, this.userNickname, this.messageContent, this.messageTime);

  factory ChatObject.fromJson(Map<String, dynamic> json) {
    return ChatObject(
      json['userId'],
      json['userNickname'],
      json['messageContent'],
      json['messageTime'],
    );
  }
}
