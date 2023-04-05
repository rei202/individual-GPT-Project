import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Color notMeColor = Colors.grey.shade200;
Color myColor = Colors.deepPurple.shade300;

class MessageItem extends StatefulWidget {
  final String text;
  final bool isMe;
  final language;

  const MessageItem({Key? key, required this.text, required this.isMe,required this.language})
      : super(key: key);

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  FlutterTts flutterTts = FlutterTts();

  Future<void> speak(text) async {
    await flutterTts.setLanguage(widget.language == "vietnamese"?"vn-VN": "en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.language);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (!widget.isMe
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: notMeColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(Icons.face_sharp, size: 30, color: myColor),
                  )
                : Container()),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.all(10),
              child: Text(widget.text,
                  style: TextStyle(
                      color: widget.isMe ? Colors.white : Colors.black,
                      fontSize: 16)),
              decoration: BoxDecoration(
                  color: !widget.isMe ? notMeColor : myColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
            (!widget.isMe
                ? IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    onPressed: () {
                      speak(widget.text);
                    })
                : Container())
          ],
        ));
  }
}
