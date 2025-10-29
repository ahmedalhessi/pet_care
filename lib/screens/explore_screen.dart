import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_app/screens/api_pet_details.dart';

import '../api/api_service.dart';
import '../bloc/bloc/api_bloc.dart';
import '../bloc/events/api_events.dart';
import '../bloc/states/api_states.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatApiBloc(ApiService())..add(FetchCatsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cat Gallery'), centerTitle: true),
        body: BlocBuilder<CatApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEB4747)),
              );
            } else if (state is ApiLoadedState) {
              final cats = state.data;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  final cat = cats[index];
                  final breed = cat.breeds.first;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApiPetDetails(cat: cat),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(cat.imageUrl, fit: BoxFit.cover),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black54],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Text(
                              breed.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ApiErrorState) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
