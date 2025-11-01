import 'package:flutter/cupertino.dart';

@immutable
abstract class SearchEvent {}

class GetSearchAutoResultsEvent extends SearchEvent {
  final String query;
  GetSearchAutoResultsEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {}
