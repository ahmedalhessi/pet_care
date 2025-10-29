import 'package:sqflite/sqflite.dart';
import '/database/db_controller.dart';
import '/model/pet_vaccine.dart';

class PetVacDBController {
  final Database _database = DbController().database;

  Future<int> create(int petId, int vaccineId) {
    return _database.rawInsert(
      'INSERT INTO pet_vaccines VALUES($petId, $vaccineId)',
    );
  }

  Future<bool> delete(int petId, int vaccineId) async {
    int countOfDeletedRows = await _database.delete(
      PetVaccine.tableName,
      where: 'pet_id = ? AND vaccine_id = ?',
      whereArgs: [petId, vaccineId],
    );
    return countOfDeletedRows > 0;
  }

  Future<List<PetVaccine>> read(int petId, int petType) async {
    List<Map<String, dynamic>> rowsMap = await _database.rawQuery(
      'select * from vaccines left join (select * from pet_vaccines where pet_vaccines.pet_id = $petId) "y" on vaccines.id = "y".vaccine_id where vaccines.pet_type = $petType',
    );
    return rowsMap.map((rowMap) => PetVaccine.fromMap(rowMap)).toList();
  }
}
