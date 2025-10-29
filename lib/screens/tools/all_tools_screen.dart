import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/bloc/tool_bloc.dart';
import '/bloc/events/tool_crud_event.dart';
import '/bloc/states/tool_crud_state.dart';
import '/utils/helpers.dart';
import '/widgets/tool_row.dart';

class AllToolsScreen extends StatefulWidget {
  const AllToolsScreen({Key? key}) : super(key: key);

  @override
  State<AllToolsScreen> createState() => _AllToolsScreenState();
}

class _AllToolsScreenState extends State<AllToolsScreen> with Helpers {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ToolBloc>(context).add(ToolReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tools'), centerTitle: true),
      body: BlocConsumer<ToolBloc, ToolCrudState>(
        listenWhen: (previous, current) =>
            current is ToolProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ToolProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
        },
        buildWhen: (previous, current) =>
            current is ToolLoadingState || current is ToolReadState,
        builder: (context, state) {
          if (state is ToolLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ToolReadState && state.tools.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsetsDirectional.all(24),
              itemBuilder: (context, index) {
                return ToolRow(
                  name: state.tools[index].name,
                  type: state.tools[index].petType == 0 ? 'Cat' : 'Dog',
                  onPressed: () {
                    deleteTool(context, index: index);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 24);
              },
              itemCount: state.tools.length,
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
            Navigator.pushNamed(context, '/add_tool_screen');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void deleteTool(BuildContext context, {required int index}) {
    BlocProvider.of<ToolBloc>(context).add(ToolDeleteEvent(index));
  }
}
