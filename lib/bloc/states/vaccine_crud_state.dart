import '/model/vaccine.dart';

abstract class VaccineCrudState {}

enum ProcessType {
  create,
  // update,
  delete,
}

class VaccineLoadingState extends VaccineCrudState {}

class VaccineProcessState extends VaccineCrudState {
  final String message;
  final bool success;
  final ProcessType processType;

  VaccineProcessState(this.processType, this.message, this.success);
}

class VaccineReadState extends VaccineCrudState {
  final List<Vaccine> vaccines;

  VaccineReadState(this.vaccines);
}
