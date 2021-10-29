import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_with_bloc/shared/BlocObserver.dart';
import 'modules/splash_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash_screen(),
    );
  }
}