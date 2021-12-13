import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cafe_app/cafe/viewmodels/cafe_info_viewmodel.dart';
import 'bottom_navigation_event.dart';
import 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial());
  
  int currentIndex = 0;


  @override
  Stream<BottomNavigationState> mapEventToState(
    BottomNavigationEvent event,
  ) async* {
    if(event is Initial) {
      yield HomePageLoaded();
    }

    if(event is PageSelected) {
      print("test " + event.indexPage.toString());
      if(event.indexPage == 0 && currentIndex != 0) {
        yield HomePageLoaded();
      }
      else if(event.indexPage == 2) {
        yield PromotionPageLoaded();
      }
      else if(event.indexPage == 3) {
        yield AuthenPageLoaded();
      }

      this.currentIndex = event.indexPage;
    }
  }
}
