import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:todo_app_with_bloc/shared/components/components.dart';
import 'package:todo_app_with_bloc/shared/cubit/cubit.dart';
import 'package:todo_app_with_bloc/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class home_layout extends StatelessWidget{
  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var titlecontroller=TextEditingController();
  var timecontroller=TextEditingController();
  var datecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder:(context, state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor:Colors.black,
          key: scaffoldkey,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(cubit.titles[cubit.currentindex],
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                color: Colors.amber,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
          ),
          body: cubit.Screens[cubit.currentindex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff171717),
            onPressed: (){
              if (cubit.isBottomSheetShow) {
                if(formkey.currentState!.validate()){
                  cubit.insertToDatabase(
                    title: titlecontroller.text, 
                    date: datecontroller.text, 
                    time: timecontroller.text,
                    );
                  Navigator.pop(context);
                  titlecontroller.clear();
                  datecontroller.clear();
                  timecontroller.clear();
                  cubit.FloatingActionButtonChange(
                    icon: Icon(
                      LineIcons.edit,
                      color: Colors.white,
                    ), 
                  isShow: false,
                  );
                }
              }
              else{
                cubit.FloatingActionButtonChange(
                  isShow: true, 
                  icon: Icon(
                    LineIcons.plus,
                    color: Colors.amber,
                  ),
                );
              scaffoldkey.currentState!.showBottomSheet((context) =>
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: Colors.white10,
                    ),
                    height: 50.0,
                    child: Center(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25.0,
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.amber.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.normal
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110.0,
                          ),
                          Text(
                            'Add Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xff171717),
                    ),
                      child: Form(
                        key:formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BulidTextFormField(
                              validate:(value){
                                if(value!.isEmpty)
                                {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              labtext: 'Task Title', 
                              preicon: LineIcons.tasks, 
                              textcontroller: titlecontroller, 
                              keyboardtype: TextInputType.text,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            BulidTextFormField(
                              ontap: (){
                                showMaterialTimePicker(
                                  context: context, 
                                  selectedTime: TimeOfDay.now(),
                                ).then((value){
                                  timecontroller.text=value!.format(context).toString();
                                });
                              },
                              validate:(value){
                                if(value!.isEmpty)
                                {
                                  return 'Time must not be empty';
                                }
                                return null;
                              },
                              labtext: 'Time', 
                              preicon: LineIcons.clock, 
                              textcontroller: timecontroller, 
                              keyboardtype: TextInputType.text,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            BulidTextFormField(
                              ontap: (){
                                showMaterialDatePicker(
                                  context: context, 
                                  selectedDate: DateTime.now(), 
                                  firstDate: DateTime.now(), 
                                  lastDate: DateTime.parse('2021-10-28'),
                                ).then((value) {
                                  datecontroller.text=DateFormat.yMMMd().format(value!).toString();
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty)
                                {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },
                              labtext: 'Date', 
                              preicon: LineIcons.calendar, 
                              textcontroller: datecontroller, 
                              keyboardtype: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
              elevation: 20.0,
              backgroundColor: Color(0xff171717),
              shape: RoundedRectangleBorder(
                borderRadius: 
                BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              ).closed.then((value) 
              {
                cubit.FloatingActionButtonChange(
                  isShow: false, 
                  icon: Icon(
                    LineIcons.edit,
                    color: Colors.white,
                  ),
                );
            });
          }
        },
            child: cubit.fabIcon,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              backgroundColor: Color(0x95171717),
              selectedItemColor: Colors.amber[700],
              onTap: (index){
                cubit.currentindex=index;
                cubit.BottomNavigtionBarChange();
              },
              currentIndex:cubit.currentindex,
              items:[
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon: Icon(
                    LineIcons.tasks,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(
                    LineIcons.checkCircle,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: Icon(
                    LineIcons.archive,
                  ),
                ),
              ], 
            ),
          ),
        ); 
      }),
    );
  }
}