import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/database/controllers/pet_vac_db_controller.dart';
import '/model/pet_vaccine.dart';
import '/utils/helpers.dart';

// ignore: must_be_immutable
class PetVaccinesScreen extends StatefulWidget {
  PetVaccinesScreen({required this.petId, required this.petType, super.key});
  late int petId;
  late int petType;

  @override
  State<PetVaccinesScreen> createState() => _PetVaccinesScreenState();
}

class _PetVaccinesScreenState extends State<PetVaccinesScreen> with Helpers {
  final PetVacDBController _petVacDBController = PetVacDBController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccines'), centerTitle: true),
      body: FutureBuilder<List<PetVaccine>>(
        future: _petVacDBController.read(widget.petId, widget.petType),
        builder: (BuildContext context, AsyncSnapshot<List<PetVaccine>> snapshot) {
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
                        'No vaccines were added to this pet!',
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
                            'These are the list of vaccines that are available for your pet, please check the vaccines you already gave to your pet.',
                            style: GoogleFonts.nunito(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'List of available vaccines',
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
                                    fontSize: 20,
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
                                      vaccineId:
                                          snapshot.data![index].vaccineId,
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
    required int vaccineId,
  }) async {
    if (flag) {
      await _petVacDBController.create(petId, vaccineId);
    } else {
      await _petVacDBController.delete(petId, vaccineId);
    }
  }
}
