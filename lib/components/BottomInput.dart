import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/providers/MessageProvider.dart';
import 'package:gpt_flutter/services/AiHandler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/Message.dart';
import 'SendToggleButton.dart';

class BottomInput extends ConsumerStatefulWidget {
  const BottomInput({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomInput> createState() => _BottomInputState();
}

class _BottomInputState extends ConsumerState<BottomInput> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool isType = false;
  final messageController = TextEditingController();
  String lastWords = 'welcome to ads';
  bool enableHandFree = false;
  AIHandler openAi = AIHandler();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      messageController.text = result.recognizedWords;
      if (messageController.text.isNotEmpty) {
        isType = true;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black54, blurRadius: 5.0, offset: Offset(0.0, 0.75))
      ], color: Colors.deepPurple.shade50),
      child: Column(
        children: [
          Text(
            _speechToText.isListening
                ? '$_lastWords'
                // If listening isn't active but could be tell the user
                // how to start it, otherwise indicate that speech
                // recognition is not yet ready or not supported on
                // the target device
                : _speechEnabled
                    ? 'Tap the microphone to start listening...'
                    : 'Speech not available',
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: messageController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                isType = true;
                              });
                            } else {
                              setState(() {
                                isType = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Start typing or taking...'))),
                  SizedBox(
                    width: 6,
                  ),
                  (isType
                      ? SendButton(
                          sendTextMessage: () {
                            sendTextMessage(messageController.text);
                          },
                        )
                      : Container())
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                    fixedSize: const Size(70, 70),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                    child: Transform.scale(
                        scale: 0.75,
                        child: Row(children: [
                          Text("hand-free"),
                          Checkbox(
                            value: enableHandFree,
                            onChanged: (bool? value) {
                              setState(() {
                                enableHandFree = value!;
                              });
                            },
                          )
                        ])))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendTextMessage(String text) async {
    print("send");
    final messages = ref.read(messagesProvider.notifier);
    addToMessageList(DateTime.now().toString(), text, true);
    final response = await openAi.getResponse(text);
    print(response);
    addToMessageList(DateTime.now().toString() , response, false);

  }

  void addToMessageList(String id, String text, bool isMe) {
    final messages = ref.read(messagesProvider.notifier);
    messages.add(Message(
      id,
      text,
      isMe,
    ));
  }
}
