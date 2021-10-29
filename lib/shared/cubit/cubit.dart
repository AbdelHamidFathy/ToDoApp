import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:todo_app_with_bloc/modules/archived_screen.dart';
import 'package:todo_app_with_bloc/modules/done_screen.dart';
import 'package:todo_app_with_bloc/modules/tasks_screen.dart';
import 'package:todo_app_with_bloc/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());

   static AppCubit get(context) => BlocProvider.of(context);

   Database? database;
   var currentindex=0;
   List<Widget>Screens=[
     tasks_screen(),
     done_screen(),
     archived_screen()
   ];
   List<String> titles=[
     'Tasks',
     'Done Tasks',
     'Archived Tasks',
   ];
   bool isBottomSheetShow =false;
   Icon fabIcon=Icon(LineIcons.edit,color: Colors.white,);
   List<Map>newTasks=[];
   List<Map>doneTasks=[];
   List<Map>archivedTasks=[];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppDatabaseCreatedState());
    });
  }
  void getFromDatabase(database){
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
     database!.rawQuery('SELECT * FROM tasks').then((value) => {
       value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'Done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      }),
      emit(AppGetFromDatabaseState()),
      print(value),
    });
  }
  insertToDatabase({
    required String title,
    required String date,
    required String time,
  })  {
     database!.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }
  void BottomNavigtionBarChange(){
    emit(AppBottomnavigationBarChangeState());
  }
  void FloatingActionButtonChange({
    required bool isShow,
    required Icon icon,
  }){
    isBottomSheetShow=isShow;
    fabIcon=icon;
    emit(AppFloatingActionButtonChangeState());
  }

  void UpdateData({
    required String status,
    required int id,
  })async{
    await database!.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status', id]).then((value)  {
      emit(AppUpdateDatabaseState());
      getFromDatabase(database);
    });
  }
  void DeleteData({
    required int id,
  }){
    database
    !.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }
}