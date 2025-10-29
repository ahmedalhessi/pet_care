import 'package:sqflite/sqflite.dart';
import '/database/db_controller.dart';
import '/database/db_operations.dart';
import '/model/tool.dart';

class ToolDbController implements DbOperations<Tool> {
  final Database _database = DbController().database;

  @override
  Future<int> create(Tool model) {
    return _database.insert(Tool.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRows = await _database.delete(
      Tool.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<Tool>> read() async {
    List<Map<String, dynamic>> rowsMap = await _database.query(Tool.tableName);
    return rowsMap.map((rowMap) => Tool.fromMap(rowMap)).toList();
  }

  @override
  Future<Tool?> show(int id) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(
      Tool.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsMap.isNotEmpty ? Tool.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Tool model) async {
    int countOfUpdatedRows = await _database.update(
      Tool.tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return countOfUpdatedRows > 0;
  }
}
