// import 'package:flutter/material.dart';
// import 'package:gpt_flutter/database/message_database.dart';
// import 'package:gpt_flutter/models/Message.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class MessageTable{
//   static const String TABLE_NAME = 'messsage';
//   static const CREATE_TABLE_QUERY  = '''
//   CREATE TABLE $TABLE_NAME (
//   id TEXT PRIMARY KEY,
//   text TEXT,
//   isMe INTEGER
//   );
//    ''';
//
//   Future<int> insertMessage(Message message){
//     final Database db = MessageDatabase.instance.database;
//     return db.insert(TABLE_NAME, message.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<void> deleteAllMessage()async {
//     final Database db = MessageDatabase.instance.database;
//     await db.delete(TABLE_NAME);
//   }
//
//   Future<List<Message>> getAllMessage() async {
//     final Database db = MessageDatabase.instance.database;
//     final List<Map<String,dynamic>> maps = await db.query("messsage");
//     return List.generate(maps.length, (index) => Message(maps[index]['id'], maps[index]['text'], maps[index]['isMe']));
//   }
//
// }