
import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class CafeLoading extends HomeState {

  @override
  String toString() => 'Cafe Loading';
}

class CafeLoaded extends HomeState {
  final List<CafeInfoModel> listCafe;

  CafeLoaded({@required this.listCafe});

  @override
  String toString() => 'Cafe Loaded : { $listCafe }';
}