import 'dart:async';
import 'package:cafe_app/cafe/blocs/home_search/bloc.dart';
import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/core/service/data_service.dart';

import 'home_event.dart';
import 'home_state.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  List<CafeInfoModel> listCafe = []; 
  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is InitialHome)  {
      yield CafeLoading();
      if(DatabaseService.listCafe == null || DatabaseService.changeData)
        listCafe = await DatabaseService.getCafeInfo();
      print(listCafe.length);
      print("EVENT : 1");
      DatabaseService.changeData = false;
      yield CafeLoaded(listCafe: listCafe);
    }
    if (event is SearchCafe) {
      print("SEARCH");
      yield CafeLoading();
      List<CafeInfoModel> newListCafe = List<CafeInfoModel>();
      listCafe.forEach((item) {
        if (item.cafeName.toLowerCase().contains(event.text.toLowerCase())) {
          newListCafe.add(item);
        }
      });

      yield CafeLoaded(listCafe: newListCafe);
    }
  }
}
