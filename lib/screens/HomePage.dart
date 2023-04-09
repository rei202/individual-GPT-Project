import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:gpt_flutter/components/BottomInput.dart';
import 'package:gpt_flutter/components/MessageItem.dart';
import 'package:gpt_flutter/providers/MessageProvider.dart';
import '../components/BottomSheetSwitch.dart';
import '../database/message_database.dart';
import '../models/Message.dart';

const List<String> list = <String>['Vietnamese', 'English'];
List<Map<String,String>> messages = [];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Default placeholder text.
  String dropdownValue = list.first;
  bool _isSpeechModeSwitch = true;
  final ScrollController _scrollController = ScrollController();
  String language = "english";

  // MessageTable messageTable = MessageTable();

  @override
    initState()  {
    // TODO: implement initState
    super.initState();
    onStart();

  }
  void onStart() async {
    List<Message> list =  await MessageDatabase().getAllMessage();
    print(list);
    final messages = ref.read(messagesProvider.notifier);
    messages.addList(list);
  }
  void deleteMessage() {
    final messages = ref.read(messagesProvider.notifier);
    messages.deleteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat".tr), actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.settings,
            size: 30,
          ),
          tooltip: 'Show Snackbar',
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 230,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Setting".tr,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                        const Divider(),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Enable auto speech".tr,
                                style: TextStyle(fontSize: 16),
                              ),
                              BottomSheetSwitch(
                                switchValue: _isSpeechModeSwitch,
                                valueChanged: (value) {
                                  setState(() {
                                    _isSpeechModeSwitch = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Language'.tr,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 160,
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 5),
                                        child: Column(children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                "Language".tr,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          const Divider(),
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Vietnamese".tr,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  language == "vietnamese"
                                                      ? Icon(
                                                          Icons.check_outlined,
                                                          color:
                                                              Colors.deepPurple,
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                language = "vietnamese";
                                              });
                                              Get.updateLocale(Locale('vn', 'VN'));
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  language = "english";
                                                });
                                                Get.updateLocale(Locale("en", 'US'));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "English".tr,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    language != "vietnamese"
                                                        ? Icon(
                                                            Icons
                                                                .check_outlined,
                                                            color: Colors
                                                                .deepPurple,
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              )),
                                        ])),
                                  );
                                });
                          },
                        ),
                        const Divider(),
                        Container(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () async {
                                await MessageDatabase().deleteAllMessage();
                                deleteMessage();
                                Navigator.pop(context);
                              },
                              child: Text("Delete chat history".tr,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red)),
                            ))
                      ],
                    ),
                  );
                });
          },
        ),
      ]),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 2,
            color: Colors.deepPurple.shade50,
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final messages = ref.watch(messagesProvider).reversed.toList();
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageItem(
                      text: messages[index].text, isMe: messages[index].isMe, language: language,);
                },
              );
            }),
            // child: ListView(children: [
            //     MessageItem(text: "list giving the asset and other descriptors for the font. For example", isMe: false),
            //   MessageItem(text: "list giving the asset and other descriptors for the font. For example", isMe: true)
            //
            // ],),
          ),
          BottomInput(_isSpeechModeSwitch, language, messages)
        ],
      )),
    );
  }
}
