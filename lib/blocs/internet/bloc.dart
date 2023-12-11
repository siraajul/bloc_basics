import 'dart:async';
import 'package:bloc_understanding/blocs/internet/event.dart';
import 'package:bloc_understanding/blocs/internet/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));

    on<InternetGetEvent>((event, emit) => emit(InternetGetState()));

    connectivitySubscription = _connectivity.onConnectivityChanged.listen((result){
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        add(InternetGetEvent());
      }
      else{
        add(InternetLostEvent());
      }
    });
  }
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
