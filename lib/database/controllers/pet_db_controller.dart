import 'package:sqflite/sqflite.dart';
import '/database/db_controller.dart';
import '/database/db_operations.dart';
import '/model/pet.dart';
import '/preferences/shared_pref_controller.dart';

class PetDBController implements DbOperations<Pet> {
  final Database _database = DbController().database;

  @override
  Future<int> create(Pet model) {
    return _database.insert(Pet.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRows = await _database.delete(
      Pet.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<Pet>> read() async {
    int userId =
        SharedPrefController().getValueFor<int>(key: PrefKeys.id.name) ?? -1;
    List<Map<String, dynamic>> rowsMap = await _database.query(
      Pet.tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return rowsMap.map((rowMap) => Pet.fromMap(rowMap)).toList();
  }

  @override
  Future<Pet?> show(int id) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(
      Pet.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsMap.isNotEmpty ? Pet.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Pet model) async {
    int countOfUpdatedRows = await _database.update(
      Pet.tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return countOfUpdatedRows > 0;
  }
}
