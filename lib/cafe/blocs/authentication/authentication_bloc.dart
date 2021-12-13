import 'dart:async';

import 'package:cafe_app/cafe/blocs/authentication/bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:cafe_app/core/service/fire_store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as Path;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      DatabaseService.getCafeInfo();
      user = _auth.currentUser;

      if (user != null) {
        print("1111111111");
        yield* mapEventForAuthen();
      } else {
        print("2222222");
        yield AuthenticationUnauthenticated();
      }
      
    }

    if (event is LoggedIn) {
      yield* mapEventForAuthen();
    }

    if (event is LoggedOut) {
      _auth.signOut();
      DatabaseService.profileImagePath = "";
      yield AuthenticationUnauthenticated();
    }

    if (event is ChangeProfile) {
      var _image = event.image;
      var path = 'profile/${Path.basename(_image.path)}';
      var storageReference = FirebaseStorage.instance.ref().child(path);

      await storageReference.putFile(_image);

      User user = FirebaseAuth.instance.currentUser;
      user.updateProfile(photoURL: path);
      yield AuthenticationLoading();
      var urlProfile = await storageReference.getDownloadURL();
        DatabaseService.profileImagePath = urlProfile;
      print("URL : " + urlProfile);
      yield AuthenticationAuthenticated(urlProfile: urlProfile);
    }
  }

  Stream<AuthenticationState> mapEventForAuthen() async* {
    User user = FirebaseAuth.instance.currentUser;
    DatabaseService.getRole(user);
    print(DatabaseService.userRole);

    final ref = FirebaseStorage.instance.ref().child(user.photoURL);
    var urlProfile = await ref.getDownloadURL();

    DatabaseService.profileImagePath = urlProfile;
    print("URL PROFILE : " + urlProfile);
    yield AuthenticationAuthenticated(urlProfile: urlProfile);
  }
}
