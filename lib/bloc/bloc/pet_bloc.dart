import 'package:flutter_bloc/flutter_bloc.dart';
import '/database/controllers/pet_db_controller.dart';
import '/model/pet.dart';
import '/bloc/events/pet_crud_event.dart';
import '/bloc/states/pet_crud_state.dart';

class PetBloc extends Bloc<PetCrudEvent, PetCrudState> {
  PetBloc(super.initialState) {
    on<PetCreateEvent>(onCreateEvent);
    on<PetReadEvent>(onReadEvent);
    on<PetUpdateEvent>(onUpdateEvent);
    on<PetDeleteEvent>(onDeleteEvent);
  }

  List<Pet> _data = <Pet>[];
  final PetDBController _petDbController = PetDBController();

  void onCreateEvent(
    PetCreateEvent event,
    Emitter<PetCrudState> emitter,
  ) async {
    int newRowId = await _petDbController.create(event.pet);
    if (newRowId != 0) {
      event.pet.id = newRowId;
      _data.add(event.pet);
      emitter(PetReadState(_data));
    }
    emitter(
      PetProcessState(
        PetProcessType.create,
        newRowId != 0 ? 'Added successfully' : 'Failed to add!',
        newRowId != 0,
      ),
    );
  }

  void onReadEvent(PetReadEvent event, Emitter<PetCrudState> emitter) async {
    emitter(PetLoadingState());
    _data = await _petDbController.read();
    emitter(PetReadState(_data));
  }

  void onUpdateEvent(
    PetUpdateEvent event,
    Emitter<PetCrudState> emitter,
  ) async {
    bool updated = await _petDbController.update(event.pet);
    if (updated) {
      int index = _data.indexWhere((element) => element.id == event.pet.id);
      if (index != -1) {
        _data[index] = event.pet;
        emitter(PetReadState(_data));
      }
    }
    emitter(
      PetProcessState(
        PetProcessType.update,
        updated ? 'Updated successfully' : 'Update failed!',
        updated,
      ),
    );
  }

  void onDeleteEvent(
    PetDeleteEvent event,
    Emitter<PetCrudState> emitter,
  ) async {
    // _data.indexWhere((Pet pet) => pet.id == event.id);
    // bool deleted = await _petDbController.delete(_data[event.index].id);
    bool deleted = await _petDbController.delete(event.id);
    if (deleted) {
      // _data.removeAt(event.index);
      _data.removeAt(_data.indexWhere((Pet pet) => pet.id == event.id));
      emitter(PetReadState(_data));
    }
    emitter(
      PetProcessState(
        PetProcessType.delete,
        deleted ? 'Deleted successfully' : 'Delete failed!',
        deleted,
      ),
    );
  }
}
