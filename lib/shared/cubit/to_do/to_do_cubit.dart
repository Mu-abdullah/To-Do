import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screens.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  //layouts
  int currentIndex = 0;
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void changeNavBottomBar(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeFloatingBottom({required bool isShow, required IconData icon}) {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeFloatingBottom());
  }

  // database transaction.....
  // 1. create database
  // 2. create tables in database
  // 3. open database
  // 4. insert in database
  // 5. get in database
  // 6. update in database
  // 7. delete from database

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  // create database
  createDataBase() async {
    openDatabase(
      'todo.db',
      version: 1,
      // create table
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('data base created');
        }).catchError((error) {
          print('error when create table ${error.toString()}');
        });
      },
      // open database
      onOpen: (database) {
        getDataFromDataBase(database);
        print('data base opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  // insert to database
  insertToDataBase({required title, required data, required time}) async {
    await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, data, time,status)VALUES("$title","$data","$time", "new")')
          .then((value) {
        print('$value inserted successfully ');

        emit(AppInsertDatabaseState());

        // getDataFromDataBase(database);
        print(value);
      }).catchError((error) {
        print('error when insert new Row ${error.toString()}');
      });
    });
  }

  // get from database
  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDataLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archiveTasks.add(element);
        }
      });
      emit(AppGetFromDatabaseState());
    });
  }

  // update to database
  updateToDatabase({required String status, required int id}) async {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateFromDatabaseState());
    });
  }

  // delete from database
  deleteFromDatabase({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }
}
