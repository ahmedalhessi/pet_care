import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/database/controllers/pet_tool_db_controller.dart';
import '/model/pet_tool.dart';

// ignore: must_be_immutable
class PetToolsScreen extends StatefulWidget {
  PetToolsScreen({required this.petId, required this.petType, super.key});
  late int petId;
  late int petType;
  @override
  State<PetToolsScreen> createState() => _PetToolsScreenState();
}

class _PetToolsScreenState extends State<PetToolsScreen> {
  final PetToolDBController _petToolDBController = PetToolDBController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tools'), centerTitle: true),
      body: FutureBuilder<List<PetTool>>(
        future: _petToolDBController.read(widget.petId, widget.petType),
        builder: (BuildContext context, AsyncSnapshot<List<PetTool>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return snapshot.data!.isEmpty
                  ? Center(
                      child: Text(
                        'No tools are available for your pet yet!',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          decoration: TextDecoration.underline,
                          color: const Color(0xFFEB4747),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'These are the list of tools that are available for your pet, please check the tools you already have for your pet.',
                            style: GoogleFonts.nunito(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'List of available tools',
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: const Color(0xFFEB4747),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(
                                  snapshot.data![index].name,
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xFFEB4747),
                                  ),
                                ),
                                activeColor: const Color(0xFFF47C7C),
                                value: snapshot.data![index].taken,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    toggleCheckTile(
                                      context,
                                      flag: value,
                                      petId: widget.petId,
                                      toolId: snapshot.data![index].toolId,
                                    );
                                    setState(() {
                                      snapshot.data![index].taken = value;
                                    });
                                  }
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 24);
                            },
                            itemCount: snapshot.data!.length,
                          ),
                        ),
                      ],
                    );

            case ConnectionState.none:
              return Text('NO DATA', style: GoogleFonts.nunito(fontSize: 24));
          }
        },
      ),
    );
  }

  void toggleCheckTile(
    BuildContext context, {
    required bool flag,
    required int petId,
    required int toolId,
  }) async {
    if (flag) {
      await _petToolDBController.create(petId, toolId);
    } else {
      await _petToolDBController.delete(petId, toolId);
    }
  }
}
