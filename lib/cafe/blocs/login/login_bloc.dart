import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cafe_app/cafe/blocs/authentication/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc({
    @required this.authenticationBloc,
  })  : assert(authenticationBloc != null),
        super(null);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        _auth
            .signInWithEmailAndPassword(
                email: event.username, password: event.password)
            .then((user) {

          print("signed in ${user.user.email}");
        }).catchError((error) {
          LoginFailure(error: error.toString());
        });

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
