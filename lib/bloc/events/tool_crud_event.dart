import '/model/tool.dart';

abstract class ToolCrudEvent {}

class ToolCreateEvent extends ToolCrudEvent {
  final Tool tool;

  ToolCreateEvent(this.tool);
}

class ToolDeleteEvent extends ToolCrudEvent {
  final int index;

  ToolDeleteEvent(this.index);
}

class ToolReadEvent extends ToolCrudEvent {}
