class ChatRoomObject {
  final int chatroomId;
  final String chatroomName;
  final String chatroomCommoncode;
  final int headCount;

  factory ChatRoomObject.fromJson(Map<String, dynamic> json) {
    return ChatRoomObject(
      json['chatroomId'],
      json['chatroomName'],
      json['chatroomCommoncode'],
      json['headCount'],
    );
  }

  ChatRoomObject(this.chatroomId, this.chatroomName, this.chatroomCommoncode,
      this.headCount);
}
