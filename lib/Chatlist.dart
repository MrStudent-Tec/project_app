class Chatlist {
  String id;

  Chatlist({required this.id});

  factory Chatlist.fromJson(Map<String, dynamic> json) {
    return Chatlist(
      id: json['id'],
    );
  }
}
