import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:todo_app_with_bloc/shared/cubit/cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_with_bloc/shared/cubit/states.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

Widget BulidTextFormField({
  required String labtext,
  required IconData preicon,
  required TextEditingController textcontroller,
  required TextInputType keyboardtype,
  required String ?Function(String?)? validate,
  Function()?ontap,
}){
  return TextFormField(
    cursorColor: Colors.amber,
    style: TextStyle(color: Colors.white, fontSize: 12),
    onTap: ontap,
    validator:validate ,
    controller: textcontroller,
    keyboardType: keyboardtype,
    decoration: InputDecoration(
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade700, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      filled: true,
      fillColor: Colors.white10,
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white10, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade700, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: labtext,
      labelStyle: TextStyle(
        color: Colors.grey
      ),
      prefixIcon: Icon(preicon,
      color:Colors.grey,
      ),
      ),
    );
}
Widget BuildNewTask(Map task, context){
  final SlidableController slidableController = SlidableController();
  return Slidable(
        key: Key(task['id'].toString()),
        dismissal: SlidableDismissal(
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.secondary: 1.0
          },
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            AppCubit.get(context).DeleteData(id:task['id']);
          },
        ),
        controller: slidableController,
        enabled: true,
        actionExtentRatio: 0.2,
        movementDuration: Duration(microseconds: 10),
        actionPane: SlidableScrollActionPane(),
        actions: [
          IconSlideAction(
            closeOnTap: true,
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              AppCubit.get(context).DeleteData(id:task['id']);
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            child: IconSlideAction(
              closeOnTap: true,
              caption: 'Archive',
              color: Colors.grey[800],
              icon: EvaIcons.archive,
              onTap: () {
                AppCubit.get(context).UpdateData(status: 'Archive', id:task['id']);
              },
            ),
          ),
        ],
        secondaryActions: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            child: task['status'] == 'Archived' || task['status'] == 'one'
                ? IconSlideAction(
                    closeOnTap: true,
                    caption: 'Add',
                    color: Colors.amber[700],
                    icon: Icons.add,
                    onTap: () {
                      AppCubit.get(context).UpdateData(status: 'new', id:task['id']);
                    },
                  )
                : IconSlideAction(
                    closeOnTap: true,
                    caption: 'Done',
                    color: Colors.green,
                    icon: EvaIcons.checkmarkCircle,
                    onTap: () {
                      AppCubit.get(context)
                          .UpdateData(status: 'Done',id: task['id']);
                    },
                  ),
          ),
        ],
     child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xff171717),
            child: Text(
              '${task['time']}',
              style: GoogleFonts.mcLaren(
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            radius: 40.0,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${task['title']}',
                  style: GoogleFonts.lato(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${task['date']}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  
}
Widget taskBuilder({
  required List<Map> tasks,
}){
  return ConditionalBuilder(
      condition: tasks.length>0, 
      builder: (context)=> BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context,state){
       return ListView.separated(
      itemBuilder: (context,index)=>BuildNewTask(tasks[index],context), 
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsets.only(left:5.0),
        child: Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.grey,
        ),
      ), 
      itemCount: tasks.length,
    );
    }),
     fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Image(
            image:AssetImage(
              'assets/images/list.png',
            ), 
          ),
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style:GoogleFonts.mcLaren (
          textStyle:TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          ),
        ),
      ],
    ),
  ),
     );
}