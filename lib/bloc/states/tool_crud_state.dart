import '/model/tool.dart';

abstract class ToolCrudState {}

enum ProcessType { create, delete }

class ToolLoadingState extends ToolCrudState {}

class ToolProcessState extends ToolCrudState {
  final String message;
  final bool success;
  final ProcessType processType;

  ToolProcessState(this.processType, this.message, this.success);
}

class ToolReadState extends ToolCrudState {
  final List<Tool> tools;

  ToolReadState(this.tools);
}
