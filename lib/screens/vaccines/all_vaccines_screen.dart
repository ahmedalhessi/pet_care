import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/bloc/vaccine_bloc.dart';
import '/bloc/events/vaccine_crud_event.dart';
import '/bloc/states/vaccine_crud_state.dart';
import '/utils/helpers.dart';
import '/widgets/vaccine_list_tile.dart';

class AllVaccinesScreen extends StatefulWidget {
  const AllVaccinesScreen({Key? key}) : super(key: key);

  @override
  State<AllVaccinesScreen> createState() => _AllVaccinesScreenState();
}

class _AllVaccinesScreenState extends State<AllVaccinesScreen> with Helpers {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VaccineBloc>(context).add(VaccineReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccines'), centerTitle: true),
      body: BlocConsumer<VaccineBloc, VaccineCrudState>(
        listenWhen: (previous, current) =>
            current is VaccineProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as VaccineProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
        },
        buildWhen: (previous, current) =>
            current is VaccineLoadingState || current is VaccineReadState,
        builder: (context, state) {
          if (state is VaccineLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VaccineReadState && state.vaccines.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsetsDirectional.all(16),
              itemBuilder: (context, index) {
                return VaccineListTile(
                  name: state.vaccines[index].name,
                  title: state.vaccines[index].petType == 0 ? 'Cat' : 'Dog',
                  age: '${state.vaccines[index].age} Months',
                  onPressed: () {
                    deleteVaccine(context, index: index);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 24);
              },
              itemCount: state.vaccines.length,
            );
          } else {
            return const Center(child: Text('NO DATA'));
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFEB4747),
          child: const Icon(Icons.add, color: Color(0xFFFFDEDE)),
          onPressed: () {
            Navigator.pushNamed(context, '/add_vaccine_screen');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void deleteVaccine(BuildContext context, {required int index}) {
    BlocProvider.of<VaccineBloc>(context).add(VaccineDeleteEvent(index));
  }
}
