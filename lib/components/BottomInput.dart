import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpt_flutter/main.dart';
import 'package:gpt_flutter/providers/MessageProvider.dart';
import 'package:gpt_flutter/services/AiHandler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/Message.dart';
import 'SendToggleButton.dart';

class BottomInput extends ConsumerStatefulWidget {
  const BottomInput(this._isSpeechModeSwitch, {Key? key}) : super(key: key);
  final _isSpeechModeSwitch;

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
  FlutterTts flutterTts = FlutterTts();
  // MessageTable messageTable = MessageTable();

  Future<void> speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

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
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          maxLines: null,
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
                          showCursor: messageController.text.isNotEmpty,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Aa"))),
                  SizedBox(
                    width: 6,
                  ),
                  (isType
                      ? SendButton(
                          sendTextMessage: () {
                            sendTextMessage(messageController.text);
                            setState(() {
                              isType = false;
                              messageController.clear();
                            });
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
    // await messageTable.insertMessage(Message(
    //     DateTime.now().toString(), text, true));
    addToMessageList(DateTime.now().toString(), text, true);
    final response = await openAi.getResponse(text);

    print(response);
    // await messageTable.insertMessage(Message(
    //     DateTime.now().toString() , response, false));
    addToMessageList(DateTime.now().toString() , response, false);
    print(widget._isSpeechModeSwitch);
    if(widget._isSpeechModeSwitch){
       speak(response);
    }

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
