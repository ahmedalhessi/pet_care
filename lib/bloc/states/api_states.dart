import 'package:pets_app/model/api_model.dart';

abstract class ApiState {}

class ApiInitialState extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiLoadedState extends ApiState {
  final List<Cat> data;
  ApiLoadedState(this.data);
}

class ApiErrorState extends ApiState {
  final String message;
  ApiErrorState(this.message);
}
