import 'package:flutter/material.dart';
import 'package:to_do_app/shared/colors/colors.dart';
import 'package:to_do_app/shared/cubit/to_do/to_do_cubit.dart';

Widget defaultFormField(
    {required TextEditingController controller,
    required TextInputType type,
    required String lables,
    required IconData prefixIcon,
    required FormFieldValidator validator,
    Function()? onTap}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    style: const TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    keyboardType: type,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixIcon),
      labelStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      labelText: lables,
      border: const OutlineInputBorder(
        gapPadding: 10,
      ),
    ),
    onTap: onTap,
  );
}

Widget tasksItem(Map model, context) {
  return Dismissible(
    key: Key(model["id"].toString()),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Center(
              child: Text(
                '${model['time']}',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  maxLines: 1,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      color: Colors.black),
                ),
                Text(
                  '${model['data']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateToDatabase(status: "done", id: model["id"]);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.yellow,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateToDatabase(status: "archive", id: model["id"]);
            },
            icon: const Icon(
              Icons.archive_outlined,
              color: Colors.black45,
            ),
          )
        ],
      ),
    ),
    background: Container(
      color: darkRed,
      child: const Center(
        child: Text(
          "Delete",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(id: model["id"]);
    },
  );
}

Widget myDivider() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 50, end: 50),
    child: Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey[400],
    ),
  );
}
