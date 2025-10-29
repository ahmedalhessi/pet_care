import 'package:sqflite/sqflite.dart';
import '/database/db_controller.dart';
import '/model/pet_tool.dart';

class PetToolDBController {
  final Database _database = DbController().database;

  Future<int> create(int petId, int toolId) async {
    return await _database.rawInsert(
      'INSERT INTO pet_tools VALUES($petId, $toolId)',
    );
  }

  Future<bool> delete(int petId, int toolId) async {
    int countOfDeletedRows = await _database.delete(
      PetTool.tableName,
      where: 'pet_id = ? AND tool_id = ?',
      whereArgs: [petId, toolId],
    );
    return countOfDeletedRows > 0;
  }

  Future<List<PetTool>> read(int petId, int petType) async {
    List<Map<String, dynamic>> rowsMap = await _database.rawQuery(
      'select * from tools left join (select * from pet_tools where pet_tools.pet_id = $petId) "y" on tools.id = "y".tool_id where tools.pet_type = $petType',
    );
    return rowsMap.map((rowMap) => PetTool.fromMap(rowMap)).toList();
  }
}
