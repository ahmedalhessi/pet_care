import '/model/pet.dart';

abstract class PetCrudState {}

enum PetProcessType { create, update, delete }

class PetLoadingState extends PetCrudState {}

class PetProcessState extends PetCrudState {
  final String message;
  final bool success;
  final PetProcessType processType;

  PetProcessState(this.processType, this.message, this.success);
}

class PetReadState extends PetCrudState {
  final List<Pet> data;
  PetReadState(this.data);
}
