


import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/counter/counter_state.dart';

class CounterCubit extends Cubit<CounterState>{
  CounterCubit( ) : super(CounterInitialState());


  static CounterCubit get(context)=> BlocProvider.of(context);

  // for counter
  int counter = 0;
  void minus(){
    counter -- ;
    emit(CounterMinusState());
  }
  void plus(){
    counter ++ ;
    emit(CounterPlusState());
  }



}