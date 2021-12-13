import 'package:cafe_app/cafe/blocs/home_search/home_bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/core/service/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cafe/app.dart';
import 'cafe/blocs/authentication/authentication_bloc.dart';
import 'cafe/blocs/login/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.getInstance();
  await Firebase.initializeApp(); 
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
          create: (context) => BottomNavigationBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authenticationBloc: AuthenticationBloc()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
      ],
      child: App(),
    ),
  );
}
