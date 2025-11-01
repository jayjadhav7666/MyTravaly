part of 'search_auto_bloc.dart';

@immutable
abstract class SearchState {}
class SearchInitialState extends SearchState {}

class SearchAutoLoadingState extends SearchState {}

class SearchAutoSuccessState extends SearchState {
  final SearchAuto results;
  SearchAutoSuccessState({required this.results});
}

class SearchAutoErrorState extends SearchState {
  final String errorMessage;
  final int? statusCode;
  SearchAutoErrorState({required this.errorMessage, this.statusCode});
}