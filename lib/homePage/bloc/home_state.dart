part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Datum> hotels;
  HomeLoadedState(this.hotels);
}

class HomeErrorState extends HomeState {
  final String errorMessage;
  final int? statusCode;
  HomeErrorState(this.errorMessage, {this.statusCode});
}
