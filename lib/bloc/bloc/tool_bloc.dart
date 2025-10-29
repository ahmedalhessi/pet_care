import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/events/tool_crud_event.dart';
import '/bloc/states/tool_crud_state.dart';
import '/database/controllers/tool_db_controller.dart';
import '/model/tool.dart';

class ToolBloc extends Bloc<ToolCrudEvent, ToolCrudState> {
  ToolBloc(super.initialState) {
    on<ToolCreateEvent>(onCreateEvent);
    on<ToolReadEvent>(onReadEvent);
    on<ToolDeleteEvent>(onDeleteEvent);
  }

  List<Tool> _tools = <Tool>[];
  final ToolDbController _toolDbController = ToolDbController();

  void onCreateEvent(
    ToolCreateEvent event,
    Emitter<ToolCrudState> emitter,
  ) async {
    int newRowId = await _toolDbController.create(event.tool);
    if (newRowId != 0) {
      event.tool.id = newRowId;
      _tools.add(event.tool);
      emitter(ToolReadState(_tools));
    }
    emitter(
      ToolProcessState(
        ProcessType.create,
        newRowId != 0 ? 'Created successfully' : 'Create failed!',
        newRowId != 0,
      ),
    );
  }

  void onReadEvent(ToolReadEvent event, Emitter<ToolCrudState> emitter) async {
    emitter(ToolLoadingState());
    _tools = await _toolDbController.read();
    emitter(ToolReadState(_tools));
  }

  void onDeleteEvent(
    ToolDeleteEvent event,
    Emitter<ToolCrudState> emitter,
  ) async {
    bool deleted = await _toolDbController.delete(_tools[event.index].id);
    if (deleted) {
      _tools.removeAt(event.index);
      emitter(ToolReadState(_tools));
    }
    emitter(
      ToolProcessState(
        ProcessType.delete,
        deleted ? 'Deleted successfully' : 'Delete failed!',
        deleted,
      ),
    );
  }
}
