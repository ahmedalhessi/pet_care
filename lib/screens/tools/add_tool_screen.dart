import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/bloc/bloc/tool_bloc.dart';
import '/bloc/events/tool_crud_event.dart';
import '/bloc/states/tool_crud_state.dart';
import '/model/tool.dart';
import '/utils/helpers.dart';
import '/widgets/app_text_field.dart';

class AddToolScreen extends StatefulWidget {
  const AddToolScreen({Key? key}) : super(key: key);

  @override
  State<AddToolScreen> createState() => _AddToolScreenState();
}

class _AddToolScreenState extends State<AddToolScreen> with Helpers {
  late TextEditingController _nameEditingController;
  String? _petType;

  @override
  void initState() {
    super.initState();
    _nameEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add Tool'), centerTitle: true),
      body: BlocListener<ToolBloc, ToolCrudState>(
        listenWhen: (previous, current) =>
            current is ToolProcessState &&
            current.processType == ProcessType.create,
        listener: (context, state) {
          state as ToolProcessState;
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
                hint: 'Tool\'s Name',
                prefixIcon: Icons.home_repair_service,
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
    if (_nameEditingController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  void _save() {
    BlocProvider.of<ToolBloc>(context).add(ToolCreateEvent(tool));
  }

  Tool get tool {
    Tool tool = Tool();
    tool.name = _nameEditingController.text;
    tool.petType = _petType == 'Cat' ? 0 : 1;
    return tool;
  }
}
