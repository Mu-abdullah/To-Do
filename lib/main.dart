import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
          () {

        runApp( MyApp());
      },
      blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen()
    );
  }
}
