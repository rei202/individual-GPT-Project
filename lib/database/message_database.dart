import 'package:gpt_flutter/database/message_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Message.dart';

class MessageDatabase {
  // static const String DB_NAME = 'messsage.db';
  // static const int DB_VERSION  = 1;
  // static Database _database;
  //
  // MessageDatabase._internal();
  // static final MessageDatabase instance = MessageDatabase._internal();
  // Database get database => _database;
  //
  // init() async{
  //   _database = await openDatabase(join(await getDatabasesPath(), DB_NAME),
  //   onCreate: (db, version){
  //     db.execute(MessageTable.CREATE_TABLE_QUERY);
  //   });
  // }
  Database? _database;

  Future _createDb(Database db, int version) async {
    await db.execute('''
  CREATE TABLE Message (
  id TEXT PRIMARY KEY,
  text TEXT,
  isMe INTEGER
  );
   ''');
  }

  Future get database async {
    if (_database != null) return database;
    _database = await _init("messsage.db");
    return _database;
  }

  Future _init(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future addDataLocally({id, text, isMe}) async {
    final db = await database;
    await db.insert("Message", {"id": id, "text": text, 'isMe': isMe});
    return 'added';
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert("Message", message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future getAll() async {
    final db = await database;
    final list = await db!.query("Message");
    List temp = list;
    print(list);
    return 'successfully';
  }
  Future<List<Message>> getAllMessage() async {
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("Message");
    return List.generate(maps.length, (index) => Message(maps[index]['id'], maps[index]['text'], maps[index]['isMe']));
  }

  Future<void> deleteAllMessage()async {
    final db = await database;
    await db.delete("Message");
    print("delete Message");
  }
}
