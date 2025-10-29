// import 'package:flutter_bloc/flutter_bloc.dart';
// import '/bloc/events/pet_vaccine_crud_event.dart';
// import '/bloc/states/pet_vaccine_crud_state.dart';
// import '/database/controllers/pet_vac_db_controller.dart';
// import '/model/pet_vaccine.dart';

// class PetVaccineBloc extends Bloc<PetVaccineCrudEvent, PetVaccineCrudState> {
//   PetVaccineBloc(super.initialState) {
//     on<PetVaccineCreateEvent>(onCreateEvent);
//     on<PetVaccineReadEvent>(onReadEvent);
//     on<PetVaccineDeleteEvent>(onDeleteEvent);
//   }
//   List<PetVaccine> _petVaccines = <PetVaccine>[];
//   final PetVacDBController _petVaccineDbController = PetVacDBController();

//   void onCreateEvent(
//       PetVaccineCreateEvent event, Emitter<PetVaccineCrudState> emitter) async {
//     int newRowId =
//         await _petVaccineDbController.create(event.petId, event.vaccineId);
//     _petVaccines
//         .elementAt(
//           _petVaccines.indexWhere(
//             (PetVaccine element) => element.vaccineId == event.vaccineId,
//           ),
//         )
//         .taken = true;
//     emitter(PetVaccineReadState(_petVaccines));
//   }

//   void onReadEvent(
//       PetVaccineReadEvent event, Emitter<PetVaccineCrudState> emitter) async {
//     emitter(
//       PetVaccineLoadingState(),
//     );
//     // print('im here!!!!!!!!!!');
//     _petVaccines =
//         await _petVaccineDbController.read(event.petId, event.petType);
//     // print(event.petId);
//     emitter(
//       PetVaccineReadState(_petVaccines),
//     );
//   }

//   void onDeleteEvent(
//       PetVaccineDeleteEvent event, Emitter<PetVaccineCrudState> emitter) async {
//     bool deleted = await _petVaccineDbController.delete(
//         _petVaccines[event.index].petId ?? -1,
//         _petVaccines[event.index].vaccineId);

//     if (deleted) {
//       _petVaccines[event.index].taken = false;
//       emitter(PetVaccineReadState(_petVaccines));
//     }
//     emitter(PetVaccineProcessState(
//       ProcessType.delete,
//       deleted ? 'Deleted Successfully' : 'Delete Failed',
//       deleted,
//     ));
//   }
// }
