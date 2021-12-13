import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}
class AuthenticationInitial extends AuthenticationState {}
class AuthenticationUnintitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  final String urlProfile;

  AuthenticationAuthenticated({@required this.urlProfile});

  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  final bool firstStartApp;

  AuthenticationUnauthenticated({this.firstStartApp = false});

  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
} 
