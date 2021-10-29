import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_bloc/shared/components/components.dart';
import 'package:todo_app_with_bloc/shared/cubit/cubit.dart';
import 'package:todo_app_with_bloc/shared/cubit/states.dart';

class done_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).doneTasks;

        return taskBuilder(
          tasks: tasks,
        );
      });
  }

}