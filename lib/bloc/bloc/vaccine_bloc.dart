import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/events/vaccine_crud_event.dart';
import '/bloc/states/vaccine_crud_state.dart';
import '/database/controllers/vaccine_db_controller.dart';
import '/model/vaccine.dart';

class VaccineBloc extends Bloc<VaccineCrudEvent, VaccineCrudState> {
  VaccineBloc(super.initialState) {
    on<VaccineCreateEvent>(onCreateEvent);
    on<VaccineReadEvent>(onReadEvent);
    on<VaccineDeleteEvent>(onDeleteEvent);
  }

  List<Vaccine> _vaccines = <Vaccine>[];
  final VaccineDbController _vaccineDbController = VaccineDbController();

  void onCreateEvent(
    VaccineCreateEvent event,
    Emitter<VaccineCrudState> emitter,
  ) async {
    int newRowId = await _vaccineDbController.create(event.vaccine);
    if (newRowId != 0) {
      event.vaccine.id = newRowId;
      _vaccines.add(event.vaccine);
      emitter(VaccineReadState(_vaccines));
    }
    emitter(
      VaccineProcessState(
        ProcessType.create,
        newRowId != 0 ? 'Created successfully' : 'Create failed!',
        newRowId != 0,
      ),
    );
  }

  void onReadEvent(
    VaccineReadEvent event,
    Emitter<VaccineCrudState> emitter,
  ) async {
    emitter(VaccineLoadingState());
    _vaccines = await _vaccineDbController.read();
    emitter(VaccineReadState(_vaccines));
  }

  void onDeleteEvent(
    VaccineDeleteEvent event,
    Emitter<VaccineCrudState> emitter,
  ) async {
    bool deleted = await _vaccineDbController.delete(_vaccines[event.index].id);
    if (deleted) {
      _vaccines.removeAt(event.index);
      emitter(VaccineReadState(_vaccines));
    }
    emitter(
      VaccineProcessState(
        ProcessType.delete,
        deleted ? 'Deleted successfully' : 'Delete failed!',
        deleted,
      ),
    );
  }
}
