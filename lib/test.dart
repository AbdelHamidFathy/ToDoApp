import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Test extends StatefulWidget{
  @override
  State<Test> createState() => _TestState();
}
class _TestState extends State<Test> {
  Database? database;
@override
  void initState() {
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOOO'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.plus_one),
      ),
    );
  }
  void createDatabase()async {
    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)async {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      }
    );}
}