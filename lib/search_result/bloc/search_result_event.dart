part of 'search_result_bloc.dart';

@immutable
abstract class SearchResultEvent {}

class FetchSearchResultEvent extends SearchResultEvent {
  final String checkInDate;
  final String checkOutDate;
  final int rooms;
  final int adults;
  final int children;
  final String searchType;
  final String searchQuery;
  final int offset;
  final bool append;
  FetchSearchResultEvent({
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.searchType,
    required this.searchQuery,
    this.offset = 0,
    this.append = false,
  });
}
