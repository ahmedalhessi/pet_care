enum VaccineTableKeys {
  id,
  name,
  pet_type,
  age,
}

class Vaccine {
  late int id;
  late String name;
  late int petType;
  late int age;

  static const String tableName = 'vaccines';

  Vaccine();

  Vaccine.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap[VaccineTableKeys.id.name];
    name = rowMap[VaccineTableKeys.name.name];
    petType = rowMap[VaccineTableKeys.pet_type.name];
    age = rowMap[VaccineTableKeys.age.name];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[VaccineTableKeys.name.name] = name;
    map[VaccineTableKeys.pet_type.name] = petType;
    map[VaccineTableKeys.age.name] = age;
    return map;
  }
}
