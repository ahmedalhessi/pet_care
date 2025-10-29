import 'package:sqflite/sqflite.dart';
import '/database/db_controller.dart';
import '/database/db_operations.dart';
import '/model/vaccine.dart';

class VaccineDbController implements DbOperations<Vaccine> {
  final Database _database = DbController().database;

  @override
  Future<int> create(Vaccine model) {
    return _database.insert(Vaccine.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRows = await _database.delete(
      Vaccine.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<Vaccine>> read() async {
    List<Map<String, dynamic>> rowsMap = await _database.query(
      Vaccine.tableName,
    );
    return rowsMap.map((rowMap) => Vaccine.fromMap(rowMap)).toList();
  }

  @override
  Future<Vaccine?> show(int id) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(
      Vaccine.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsMap.isNotEmpty ? Vaccine.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Vaccine model) async {
    int countOfUpdatedRows = await _database.update(
      Vaccine.tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return countOfUpdatedRows > 0;
  }
}
