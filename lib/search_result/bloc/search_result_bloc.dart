import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travely/search_result/model/search_result_model.dart';
import 'package:my_travely/search_result/repository/search_result_repository.dart';
part 'search_result_event.dart';
part 'search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final SearchResultCompleteRepository repository;

  SearchResultBloc(this.repository) : super(SearchResultInitial()) {
    on<FetchSearchResultEvent>(_getSearchResults);
  }

  Future<void> _getSearchResults(
    FetchSearchResultEvent event,
    Emitter<SearchResultState> emit,
  ) async {
    final currentState = state;
    List<ArrayOfHotelList> existingHotels = [];

    if (event.append && currentState is SearchResultSuccess) {
      existingHotels = currentState.results.data?.arrayOfHotelList ?? [];
    } else if (!event.append) {
      if (kDebugMode) print('Fetching initial results...');
      emit(SearchResultLoading());
    }

    final result = await repository.fetchSearchResultsData(
      checkInDate: event.checkInDate,
      checkOutDate: event.checkOutDate,
      rooms: event.rooms,
      adults: event.adults,
      children: event.children,
      searchType: event.searchType,
      searchQuery: event.searchQuery,
      offset: event.offset, 
    );

    if (result.data != null) {
      final newHotels = result.data!.data?.arrayOfHotelList ?? [];
      final combined = [...existingHotels, ...newHotels];

      if (result.data!.data!.arrayOfHotelList.isEmpty) {
        result.data!.data!.arrayOfHotelList.addAll(combined);
      } else {
        result.data!.data!.arrayOfHotelList
          ..clear()
          ..addAll(combined);
      }

      emit(SearchResultSuccess(
        results: result.data!,
        hasMore: newHotels.isNotEmpty,
      ));
    } else {
      emit(SearchResultError(
        errorMessage: result.errorMessage ?? 'Something went wrong',
        statusCode: result.statusCode,
      ));
    }
  }
}
