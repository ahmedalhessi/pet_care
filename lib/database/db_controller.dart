import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController {
  static DbController? _instance;
  late Database _database;

  DbController._();

  factory DbController() {
    return _instance ??= DbController._();
  }

  Database get database => _database;

  Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'pet_app_db.sql');
    _database = await openDatabase(
      path,
      version: 1,
      onOpen: (Database database) {},
      onCreate: (Database database, int version) async {
        await database.execute(
          'CREATE TABLE users ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT NOT NULL,'
          'email TEXT NOT NULL,'
          'password TEXT NOT NULL'
          ')',
        );

        // await database.execute(
        //   'CREATE TABLE types ('
        //   'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        //   'type TEXT NOT NULL'
        //   ')',
        // );

        await database.execute(
          'CREATE TABLE pets ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT NOT NULL,'
          'gender INTEGER NOT NULL,'
          'date_of_birth TEXT NOT NULL,'
          'image TEXT NOT NULL,'
          'user_id INTEGER,'
          'pet_type INTEGER NOT NULL,'
          'FOREIGN KEY (user_id) references users(id)'
          // 'FOREIGN KEY (pet_type) references types(id)'
          ')',
        );

        await database.execute(
          'CREATE TABLE vaccines ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT NOT NULL,'
          'age int NOT NULL,'
          'pet_type INTEGER NOT NULL'
          // 'FOREIGN KEY (pet_type) references types(id)'
          ')',
        );

        await database.execute(
          'CREATE TABLE tools ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT NOT NULL,'
          'pet_type INTEGER NOT NULL'
          // 'FOREIGN KEY (pet_type) references types(id)'
          ')',
        );

        await database.execute(
          'CREATE TABLE pet_vaccines ('
          'pet_id INTEGER,'
          'vaccine_id INTEGER,'
          'FOREIGN KEY (pet_id) references pets(id),'
          'FOREIGN KEY (vaccine_id) references vaccines(id),'
          'CONSTRAINT pet_vac_pk PRIMARY KEY(pet_id, vaccine_id)'
          ')',
        );

        await database.execute(
          'CREATE TABLE pet_tools ('
          'pet_id INTEGER,'
          'tool_id INTEGER,'
          'FOREIGN KEY (pet_id) references pets(id),'
          'FOREIGN KEY (tool_id) references tools(id),'
          'CONSTRAINT pet_tool_pk PRIMARY KEY(pet_id, tool_id)'
          ')',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {},
      onDowngrade: (Database db, int oldVersion, int newVersion) {},
    );
  }
}
