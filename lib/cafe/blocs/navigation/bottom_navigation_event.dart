
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class Initial extends BottomNavigationEvent {
  @override
  String toString() => 'Initail Event';
}

class PageSelected extends BottomNavigationEvent {
  final int indexPage;
  //test
  PageSelected({@required this.indexPage});

  @override
  String toString() => 'PageSelected : { $indexPage }';
}

// class SearchCafe extends BottomNavigationEvent {
//   final List<CafeInfoModel> listCafe;

//   SearchCafe({this.listCafe});

//   @override
//   String toString() => 'SearchCafe : { $listCafe }';

// }