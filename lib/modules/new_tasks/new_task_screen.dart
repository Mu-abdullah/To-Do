import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/colors/colors.dart';
import 'package:to_do_app/shared/component/component.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_cubit.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_state.dart';

class NewTasksScreen extends StatefulWidget {
  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          var tasks = AppCubit.get(context).newTasks;
          return tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no_data.png",
                        height: 150,
                        width: 200,
                        color: darkRed,
                      ),
                      const Text(
                        "No Tasks Here,",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Please press on pin button",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      tasksItem(tasks[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: tasks.length);
        });
  }
}
