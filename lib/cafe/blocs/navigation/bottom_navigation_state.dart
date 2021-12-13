
import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();
  
  @override
  List<Object> get props => [];
}

class BottomNavigationInitial extends BottomNavigationState {}

class PageLoding extends BottomNavigationState {
  
  @override
  String toString() => 'Page Loading';
}

class HomePageLoaded extends BottomNavigationState {

  @override
  String toString() => 'Home Page Loaded';
}

class PromotionPageLoaded extends BottomNavigationState {

  @override
  String toString() => 'Promotion Page Loaded';
} 

class AuthenPageLoaded extends BottomNavigationState {
  @override
  String toString() => 'Authen Page Loaded';
}