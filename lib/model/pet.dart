enum PetTableKeys {
  id,
  name,
  pet_type,
  gender,
  date_of_birth,
  image,
  user_id,
}

class Pet {
  late int id;
  late String name;
  late int petType;
  late int gender;
  late String dateOfBirth;
  late String image;
  late int userID;

  static const String tableName = 'pets';

  Pet();

  Pet.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap[PetTableKeys.id.name];
    name = rowMap[PetTableKeys.name.name];
    petType = rowMap[PetTableKeys.pet_type.name];
    gender = rowMap[PetTableKeys.gender.name];
    dateOfBirth = rowMap[PetTableKeys.date_of_birth.name];
    image = rowMap[PetTableKeys.image.name];
    userID = rowMap[PetTableKeys.user_id.name];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[PetTableKeys.name.name] = name;
    map[PetTableKeys.pet_type.name] = petType;
    map[PetTableKeys.gender.name] = gender;
    map[PetTableKeys.date_of_birth.name] = dateOfBirth;
    map[PetTableKeys.image.name] = image;
    map[PetTableKeys.user_id.name] = userID;
    return map;
  }
}
