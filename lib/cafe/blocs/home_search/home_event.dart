
import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class InitialHome extends HomeEvent {

  @override
  String toString() => 'Initail Cafe';
}

class SearchCafe extends HomeEvent {
  final String text;

  SearchCafe({@required this.text});
  @override
  String toString() => 'Search Cafe ';
}
