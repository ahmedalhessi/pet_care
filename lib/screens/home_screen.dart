import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/bloc/bloc/pet_bloc.dart';
import '/bloc/events/pet_crud_event.dart';
import '/bloc/states/pet_crud_state.dart';
import '/screens/pet_details/pet_details_screen.dart';
import '/widgets/home_drawer/home_screen_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PetBloc>(context).add(PetReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Pets'), centerTitle: true),
      drawer: const HomeScreenDrawer(),
      body: BlocBuilder<PetBloc, PetCrudState>(
        buildWhen: (previous, current) =>
            current is PetLoadingState || current is PetReadState,
        builder: (context, state) {
          if (state is PetLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetReadState && state.data.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsetsDirectional.all(16),
              itemCount: state.data.length,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PetDetailsScreen(pet: state.data[index]),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image.memory(
                        fit: BoxFit.cover,
                        const Base64Decoder().convert(state.data[index].image),
                        height: 250,
                        width: double.infinity,
                      ),
                      Container(
                        alignment: AlignmentDirectional.center,
                        color: Colors.black26,
                        height: 50,
                        width: double.infinity,
                        child: Text(
                          state.data[index].name,
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            );
          } else {
            return Center(
              child: Text(
                'You didn\'t add any pets',
                style: GoogleFonts.nunito(
                  color: const Color(0xFFEB4747),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFEB4747),
          foregroundColor: Colors.white,
          tooltip: 'Add new pet',
          onPressed: () {
            Navigator.pushNamed(context, '/add_pet_screen');
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
