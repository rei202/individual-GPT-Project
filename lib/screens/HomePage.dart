import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_flutter/components/BottomInput.dart';
import 'package:gpt_flutter/components/MessageItem.dart';
import 'package:gpt_flutter/providers/MessageProvider.dart';
import '../components/BottomSheetSwitch.dart';

const List<String> list = <String>['Vietnamese', 'English'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Default placeholder text.
  String dropdownValue = list.first;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"), actions: <Widget>[
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
                    height: 180,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Setting",
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
                                "Enable auto speech",
                                style: TextStyle(fontSize: 16),
                              ),
                              BottomSheetSwitch(
                                switchValue: _switchValue,
                                valueChanged: (value) {
                                  _switchValue = value;
                                },
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        Container(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {},
                              child: Text("Delete chat history",
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
                height: 60,
                color: Colors.deepPurple.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 13, right: 13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.expand_more),
                          underline: SizedBox(),
                          dropdownColor: Colors.deepPurple.shade50,
                          iconSize: 30,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: list.map<DropdownMenuItem<String>>((
                              String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final messages = ref.watch(messagesProvider).reversed.toList();
                        return ListView.builder(
                          reverse: true,
                            itemCount: messages.length,
                             itemBuilder: ( context,  index) =>
                              MessageItem(text: messages[index].text, isMe: messages[index].isMe),

                           );
                      }
                    ),
                    // child: ListView(children: [
                    //     MessageItem(text: "list giving the asset and other descriptors for the font. For example", isMe: false),
                    //   MessageItem(text: "list giving the asset and other descriptors for the font. For example", isMe: true)
                    //
                    // ],),
                  )),
              BottomInput()
            ],
          )),
    );
  }
}
