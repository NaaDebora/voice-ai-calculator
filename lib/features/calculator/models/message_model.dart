class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});

  Map<String, dynamic> toJson() {
    return {'text': text, 'isUser': isUser};
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(text: json['text'] ?? '', isUser: json['isUser'] ?? false);
  }
}