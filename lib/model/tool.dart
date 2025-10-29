enum ToolTableKeys {
  id,
  name,
  pet_type,
}

class Tool {
  late int id;
  late String name;
  late int petType;

  static const String tableName = 'tools';

  Tool();

  Tool.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap[ToolTableKeys.id.name];
    name = rowMap[ToolTableKeys.name.name];
    petType = rowMap[ToolTableKeys.pet_type.name];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[ToolTableKeys.name.name] = name;
    map[ToolTableKeys.pet_type.name] = petType;
    return map;
  }
}
