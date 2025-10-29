import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '/bloc/bloc/pet_bloc.dart';
import '/bloc/events/pet_crud_event.dart';
import '/bloc/states/pet_crud_state.dart';
import '/model/pet.dart';
import '/preferences/shared_pref_controller.dart';
import '/utils/helpers.dart';
import '/widgets/app_text_field.dart';
import '/widgets/pet_details_widgets/pet_details_divider.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> with Helpers {
  XFile? pickedImage;
  late ImagePicker imagePicker;
  DateTime selectedDate = DateTime.now();
  String? _gender;
  String? _petType;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a pet'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     tooltip: 'Add Pet',
        //     onPressed: () => _performSave(),
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
      body: BlocListener<PetBloc, PetCrudState>(
        listenWhen: (previous, current) =>
            current is PetProcessState &&
            current.processType == PetProcessType.create,
        listener: (context, state) {
          state as PetProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 250,
                child: pickedImage == null
                    ? IconButton(
                        tooltip: 'Pick Image',
                        onPressed: () async => await _pickImage(),
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: Color(0xFFF47C7C),
                          size: 128,
                        ),
                      )
                    : Image.file(File(pickedImage!.path)),
              ),
              const SizedBox(height: 24),
              AppTextField(
                textController: nameController,
                hint: 'Name',
                prefixIcon: Icons.pets,
              ),
              Row(
                children: [
                  _radioTile(title: 'Male', value: 'M', groupValue: _gender),
                  _radioTile(title: 'Female', value: 'F', groupValue: _gender),
                ],
              ),
              const PetDetailsDivider(),
              Row(
                children: [
                  _radioTile(title: 'Cat', value: 'Cat', groupValue: _petType),
                  _radioTile(title: 'Dog', value: 'Dog', groupValue: _petType),
                ],
              ),
              const PetDetailsDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: const Color(0xFFEB4747),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(
                        Icons.date_range,
                        color: Color(0xFFEB4747),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(onPressed: _performSave, child: Text('Add Pet')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? img = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (img != null) {
      setState(() {
        pickedImage = img;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
    );
    if (selected != null && selected != selectedDate) {
      setState(() => selectedDate = selected);
    }
  }

  Expanded _radioTile({
    required String title,
    required String value,
    required String? groupValue,
  }) {
    return Expanded(
      child: RadioListTile(
        title: Text(
          title,
          style: GoogleFonts.nunito(color: const Color(0xFFEB4747)),
        ),
        activeColor: const Color(0xFFEB4747),
        value: value,
        groupValue: groupValue,
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              if (groupValue == _gender) {
                _gender = value;
              } else {
                _petType = value;
              }
            });
          }
        },
      ),
    );
  }

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (nameController.text.isNotEmpty && pickedImage != null) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  void _save() {
    BlocProvider.of<PetBloc>(context).add(PetCreateEvent(pet));
  }

  // void calculateDif() {
  //   final birthday = DateTime(1967, 10, 12);
  //   final date2 = DateTime.now();
  //   final difference = date2.difference(birthday).inDays;
  // }

  Pet get pet {
    Pet pet = Pet();
    pet.name = nameController.text;
    pet.petType = _petType == 'Cat' ? 0 : 1;
    pet.gender = _gender == 'M' ? 0 : 1;
    pet.dateOfBirth =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    if (pickedImage == null) {
      showSnackBar(context, message: 'Please pick an image', error: true);
    } else {
      final bytes = File(pickedImage!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      pet.image = img64;
    }

    pet.userID = SharedPrefController().getValueFor<int>(
      key: PrefKeys.id.name,
    )!;
    return pet;
  }
}
