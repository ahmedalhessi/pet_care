import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '/bloc/bloc/pet_bloc.dart';
import '/bloc/events/pet_crud_event.dart';
import '/bloc/states/pet_crud_state.dart';
import '/model/pet.dart';
import '/screens/pet_details/pet_tools_screen.dart';
import '/screens/pet_details/pet_vaccines_screen.dart';
import '/screens/pet_details/update_pet_screen.dart';
import '/utils/helpers.dart';
import '/widgets/pet_details_widgets/pet_details_button.dart';
import '/widgets/pet_details_widgets/pet_details_data.dart';
import '/widgets/pet_details_widgets/pet_details_divider.dart';

class PetDetailsScreen extends StatelessWidget with Helpers {
  const PetDetailsScreen({required this.pet, Key? key}) : super(key: key);

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePetScreen(pet: pet),
                ),
              );
            },
            icon: const Icon(Icons.build),
          ),
          IconButton(
            onPressed: () {
              _deletePet(context, id: pet.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocListener<PetBloc, PetCrudState>(
        listenWhen: (previous, current) =>
            current is PetProcessState &&
            current.processType == PetProcessType.delete,
        listener: (context, state) {
          state as PetProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
        },
        child: BlocBuilder<PetBloc, PetCrudState>(
          buildWhen: (previous, current) =>
              current is PetProcessState &&
              current.processType == PetProcessType.update,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(
                    fit: BoxFit.cover,
                    const Base64Decoder().convert(pet.image),
                    height: 245,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  PetDetailsData(title: 'Pet Name', data: pet.name),
                  const PetDetailsDivider(),
                  PetDetailsData(
                    title: 'Pet Type',
                    data: pet.petType == 0 ? 'Cat' : 'Dog',
                  ),
                  const PetDetailsDivider(),
                  PetDetailsData(
                    title: 'Pet Gender',
                    data: pet.gender == 0 ? 'Male' : 'Female',
                  ),
                  const PetDetailsDivider(),
                  PetDetailsData(
                    title: 'Pet Age',
                    data: '${_calculateAge(pet.dateOfBirth)} Months',
                  ),
                  const PetDetailsDivider(),
                  PetDetailsButton(
                    title: 'CHECK VACCINES',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => PetVaccinesScreen(
                            petId: pet.id,
                            petType: pet.petType,
                          )),
                        ),
                      );
                    },
                  ),
                  const PetDetailsDivider(),
                  PetDetailsButton(
                    title: 'CHECK TOOLS',
                    onPressed: () {
                      print(pet.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => PetToolsScreen(
                            petId: pet.id,
                            petType: pet.petType,
                          )),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _calculateAge(String dateOfBirth) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(dateOfBirth);
    int days = DateTime.now().difference(date).inDays;
    return (days / 30).toStringAsFixed(0);
  }

  void _deletePet(BuildContext context, {required int id}) {
    BlocProvider.of<PetBloc>(context).add(PetDeleteEvent(id));
  }
}
