class Message {
  final String id;
  final String text;
  final bool isMe;



  Message(this.id, this.text, this.isMe);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isMe': isMe
    };
  }
}