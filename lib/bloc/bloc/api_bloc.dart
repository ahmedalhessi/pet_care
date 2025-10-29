import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import '../events/api_events.dart';
import '../states/api_states.dart';

class CatApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiService _catApiService;

  CatApiBloc(this._catApiService) : super(ApiInitialState()) {
    on<FetchCatsEvent>(_onFetchCats);
  }

  Future<void> _onFetchCats(
    FetchCatsEvent event,
    Emitter<ApiState> emit,
  ) async {
    emit(ApiLoadingState());
    try {
      final cats = await _catApiService.fetchCats();
      if (cats.isEmpty) {
        emit(ApiErrorState('No cats with breed info found.'));
      } else {
        emit(ApiLoadedState(cats));
      }
    } catch (e) {
      emit(ApiErrorState(e.toString()));
    }
  }
}
