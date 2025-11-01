part of 'search_result_bloc.dart';

@immutable
sealed class SearchResultState {}

final class SearchResultInitial extends SearchResultState {}

final class SearchResultLoading extends SearchResultState {}

final class SearchResultSuccess extends SearchResultState {
  final SearchResultModel results;
  final bool hasMore;
  SearchResultSuccess({required this.results, this.hasMore = true});
}

final class SearchResultError extends SearchResultState {
  final String errorMessage;
  final int? statusCode;
  SearchResultError({required this.errorMessage, this.statusCode});
}
