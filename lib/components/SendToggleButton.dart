import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SendButton extends StatefulWidget {
  const SendButton({Key? key, required this.sendTextMessage}) : super(key: key);
  final VoidCallback sendTextMessage;
  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
        widget.sendTextMessage,
      child: Icon(Icons.send),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15)
      ),
    );
  }
}
