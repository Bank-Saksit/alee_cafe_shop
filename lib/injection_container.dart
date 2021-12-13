import 'package:get_it/get_it.dart';

import 'cafe/blocs/authentication/authentication_bloc.dart';
import 'cafe/blocs/login/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Log In
  sl.registerFactory(
    () => LoginBloc(
      authenticationBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthenticationBloc(),
  );
}
