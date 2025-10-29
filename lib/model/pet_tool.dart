enum PetToolTableKeys {
  name,
  pet_id,
}

class PetTool {
  late String name;
  late int toolId;
  late bool taken;

  static const String tableName = 'pet_tools';

  PetTool();

  PetTool.fromMap(Map<String, dynamic> rowMap) {
    name = rowMap[PetToolTableKeys.name.name];
    toolId = rowMap['id'];
    taken = rowMap[PetToolTableKeys.pet_id.name] != null ? true : false;
  }
}
