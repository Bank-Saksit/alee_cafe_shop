import 'package:cafe_app/cafe/blocs/authentication/bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bloc.dart';
import 'package:cafe_app/cafe/pages/initial/account/account/account_page.dart';
import 'package:cafe_app/cafe/pages/initial/account/login/LoginPage.dart';
import 'package:cafe_app/cafe/pages/initial/promotion/promotion_page.dart';
import 'package:cafe_app/core/service/fire_store_service.dart';
import 'package:cafe_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/home_page.dart';

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenBloc = BlocProvider.of<AuthenticationBloc>(context)..add(AppStarted());
    final bloc = BlocProvider.of<BottomNavigationBloc>(context);
    FireStoreService.getComment("MSd4CnvkJVnOI3fVKHs"); 
    
    return BlocProvider(
      create: (context) => bloc..add(Initial()),
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        cubit: bloc,
        builder: (context, state) {
          if (state is HomePageLoaded) {
            return HomePage(navigationBloc: bloc);
          } else if (state is PromotionPageLoaded) {
            return PromotionPage(navigationBloc: bloc);
          } else if (state is AuthenPageLoaded) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              cubit: authenBloc,
              builder: (BuildContext context, AuthenticationState authenState) {
                if (authenState is AuthenticationUnauthenticated) {
                  return LoginPage(navigationBloc: bloc,authenBloc : authenBloc);
                } else if (authenState is AuthenticationAuthenticated) {
                  return AccountPage(navigationBloc: bloc,authenBloc : authenBloc,urlProfile : authenState.urlProfile);
                } else if (authenState is AuthenticationLoading) {
                  return LoadingIndigator();
                }
                return LoadingIndigator();
              },
            );
          }
          return HomePage(
            navigationBloc: bloc,
          );
        },
      ),
    );
  }
}
