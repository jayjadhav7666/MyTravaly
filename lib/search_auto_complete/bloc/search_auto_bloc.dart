import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travely/search_auto_complete/bloc/search_auto_event.dart';
import 'package:my_travely/search_auto_complete/model/search_auto_model.dart';
import 'package:my_travely/search_auto_complete/repository/search_auto_repository.dart';
import 'package:my_travely/utils/common_api_result_model.dart';

part 'search_auto_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchAutoRepository repository;

  SearchBloc(this.repository) : super(SearchInitialState()) {
    on<GetSearchAutoResultsEvent>(_getSearchResults);
    on<ClearSearchEvent>((event, emit) => emit(SearchInitialState()));
  }

  Future<void> _getSearchResults(
      GetSearchAutoResultsEvent event, Emitter<SearchState> emit) async {
    emit(SearchAutoLoadingState());

    final ApiResult<SearchAuto> result =
        await repository.fetchSearchSuggestions(event.query);

    if (result.errorMessage != null) {
      emit(SearchAutoErrorState(
          errorMessage: result.errorMessage!, statusCode: result.statusCode));
    } else if (result.data == null) {
      emit(SearchAutoErrorState(
          errorMessage: 'Unexpected error occurred', statusCode: 0));
    } else {
      emit(SearchAutoSuccessState(results: result.data!));
    }
  }
}
