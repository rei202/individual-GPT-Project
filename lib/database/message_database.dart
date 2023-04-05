// import 'package:gpt_flutter/database/message_table.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class MessageDatabase{
//   static const String DB_NAME = 'messsage.db';
//   static const int DB_VERSION  = 1;
//   static Database _database;
//
//   MessageDatabase._internal();
//   static final MessageDatabase instance = MessageDatabase._internal();
//   Database get database => _database;
//
//   init() async{
//     _database = await openDatabase(join(await getDatabasesPath(), DB_NAME),
//     onCreate: (db, version){
//       db.execute(MessageTable.CREATE_TABLE_QUERY);
//     });
//   }
//
//
// }