import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travely/homePage/model/hotels_model.dart';
import 'package:my_travely/homePage/repository/hotel_repository.dart';
import 'package:my_travely/utils/common_api_result_model.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HotelRepository repository;

  HomeBloc(this.repository) : super(HomeInitialState()) {
    on<FetchHotelsEvent>(_fetchHotels);
  }

  Future<void> _fetchHotels(
      FetchHotelsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    final ApiResult<List<Datum>> result =
        await repository.fetchHotels(event.city,event.state,event.country);

    if (result.errorMessage != null) {
      emit(HomeErrorState(result.errorMessage!, statusCode: result.statusCode));
    } else if (result.data == null) {
      emit(HomeErrorState("Unexpected error occurred", statusCode: 0));
    } else {
      emit(HomeLoadedState(result.data!));
    }
  }
}
