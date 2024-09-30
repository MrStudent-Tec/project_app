class Chat {
  String sender;
  String message;
  String url;
  String messageId;

  Chat(
      {required this.sender,
      required this.message,
      required this.url,
      required this.messageId});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      sender: json['sender'],
      message: json['message'],
      url: json['url'],
      messageId: json['messageId'],
    );
  }
}
