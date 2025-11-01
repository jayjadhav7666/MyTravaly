part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchHotelsEvent extends HomeEvent {
  final String city;
  final String state;
  final String country;
  FetchHotelsEvent(this.city,this.state,this.country);
}