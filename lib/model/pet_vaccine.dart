enum PetVaccineTableKeys {
  name,
  age,
  pet_id,
}

class PetVaccine {
  late String name;
  late int age;
  late int vaccineId;
  late bool taken;

  static const String tableName = 'pet_vaccines';

  PetVaccine();

  PetVaccine.fromMap(Map<String, dynamic> rowMap) {
    name = rowMap[PetVaccineTableKeys.name.name];
    age = rowMap[PetVaccineTableKeys.age.name];
    vaccineId = rowMap['id'];
    taken = rowMap[PetVaccineTableKeys.pet_id.name] != null ? true : false;
  }
}
