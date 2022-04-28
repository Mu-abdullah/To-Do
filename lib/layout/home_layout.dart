import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/shared/colors/colors.dart';
import 'package:to_do_app/shared/component/component.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_cubit.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_state.dart';

class HomeScreen extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dataController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: yellow,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  color: black,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDataBase(
                      title: titleController.text,
                      data: dataController.text,
                      time: timeController.text,
                    )
                        .then((value) {
                      cubit.getDataFromDataBase(cubit.database);
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.grey[200],
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                        controller: titleController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Title must not be empty';
                                          }
                                          return null;
                                        },
                                        lables: 'Title',
                                        type: TextInputType.text,
                                        prefixIcon: Icons.title),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                        controller: timeController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Time must not be empty';
                                          }
                                          return null;
                                        },
                                        lables: 'Time',
                                        type: TextInputType.datetime,
                                        prefixIcon: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        }),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                        controller: dataController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Data must not be empty';
                                          }
                                          return null;
                                        },
                                        lables: 'Data',
                                        type: TextInputType.datetime,
                                        prefixIcon: Icons.calendar_today,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2022-12-31'))
                                              .then((value) {
                                            dataController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeFloatingBottom(isShow: false, icon: Icons.edit);
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  cubit.changeFloatingBottom(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
              backgroundColor: yellow,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 8.0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNavBottomBar(index);
              },
              selectedItemColor: yellow,
              unselectedItemColor: black,
              showSelectedLabels: true,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            body:
            // state is! AppGetDataLoadingState
            //     ? Center(child: CircularProgressIndicator(color: yellow,)):
                 cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
