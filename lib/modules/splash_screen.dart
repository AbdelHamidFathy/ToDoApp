import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_with_bloc/layout/home_layout.dart';

class splash_screen extends StatefulWidget {
  
  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
     ()=>Navigator.pushReplacement(context,
       MaterialPageRoute(builder:
        (context) => home_layout()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image: AssetImage(
                    'assets/images/todo.png'
                  ),
                ),
              ),
              Text(
                'ToDo App',
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}