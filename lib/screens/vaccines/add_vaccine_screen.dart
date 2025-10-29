import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/bloc/bloc/vaccine_bloc.dart';
import '/bloc/events/vaccine_crud_event.dart';
import '/bloc/states/vaccine_crud_state.dart';
import '/model/vaccine.dart';
import '/utils/helpers.dart';
import '/widgets/app_text_field.dart';

class AddVaccineScreen extends StatefulWidget {
  const AddVaccineScreen({Key? key}) : super(key: key);

  @override
  State<AddVaccineScreen> createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> with Helpers {
  late TextEditingController _nameEditingController;
  late TextEditingController _ageEditingController;
  String? _petType;

  @override
  void initState() {
    super.initState();
    _nameEditingController = TextEditingController();
    _ageEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _ageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add Vaccine'), centerTitle: true),
      body: BlocListener<VaccineBloc, VaccineCrudState>(
        listenWhen: (previous, current) =>
            current is VaccineProcessState &&
            current.processType == ProcessType.create,
        listener: (context, state) {
          state as VaccineProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
          if (state.success) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              AppTextField(
                textController: _nameEditingController,
                hint: 'Vaccine\'s Name',
                prefixIcon: Icons.vaccines,
              ),
              const SizedBox(height: 16),
              AppTextField(
                textController: _ageEditingController,
                textInputType: TextInputType.number,
                hint: 'Pet Age',
                prefixIcon: Icons.today,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _radioTile(title: 'Cat', value: 'Cat', groupValue: _petType),
                  _radioTile(title: 'Dog', value: 'Dog', groupValue: _petType),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 45),
                  backgroundColor: const Color(0xFFEB4747),
                ),
                onPressed: () => _performSave(),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Color(0xFFFFDEDE), fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              _petType = value;
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
    if (_nameEditingController.text.isNotEmpty &&
        _ageEditingController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  void _save() {
    BlocProvider.of<VaccineBloc>(context).add(VaccineCreateEvent(vaccine));
  }

  Vaccine get vaccine {
    Vaccine vaccine = Vaccine();
    vaccine.name = _nameEditingController.text;
    vaccine.age = int.parse(_ageEditingController.text);
    vaccine.petType = _petType == 'Cat' ? 0 : 1;
    return vaccine;
  }
}
