import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defautltTextFormFiels({
  @required TextEditingController controller,
  @required TextInputType keyboardType,
  @required Function validtor,
  @required String labelText,
  @required IconData prefixIcon,
  Function onTap=null,
  IconData suffixIcon = null,
  Function onSuffixIconTap = null,
  bool isPassword = false,
  bool isReadOnly = false,
}
    )=>   TextFormField(
  controller: controller,
  obscureText: isPassword,
  keyboardType: keyboardType,
  readOnly: isReadOnly,
  decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(

      ),
      prefixIcon: Icon(
        prefixIcon,
      ),
      suffixIcon: suffixIcon!=null ? IconButton(
        onPressed: onSuffixIconTap,
        icon:   Icon(
          suffixIcon,
        ),
      ) : null

  ),
  validator: validtor ,
  onTap: onTap,
) ;

Widget buildTaskItem(Map model , context)=>  Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child:   Row(



      children: [



        CircleAvatar(



          radius: 40.0,



          child: Text(



              '${model['time']}'



          ),



        ),



        SizedBox(



          width: 20.0,



        ),



        Expanded(

          child: Column(



            mainAxisSize: MainAxisSize.min,



            crossAxisAlignment: CrossAxisAlignment.start,



            children: [



              Text(



                '${model['title']}',



                style: TextStyle(



                  fontSize: 20.0,



                  fontWeight: FontWeight.bold,



                ),



              ),



              SizedBox(



                height: 2.0,



              ),



              Text(



                '${model['date']}',



                style: TextStyle(



                  color: Colors.grey,



                ),



              ),







            ],



          ),

        ),



        SizedBox(



          width: 20.0,



        ),



        IconButton(

            icon: Icon(

              Icons.check_box_rounded,

              color: Colors.green,

            ),

            onPressed: (){

              AppCubit.get(context).updateData(model['id'], 'done');

            }),

        IconButton(

            icon: Icon(

              Icons.archive,

              color: Colors.black45,

            ),

            onPressed: (){

              AppCubit.get(context).updateData(model['id'], 'archived');

            }),



      ],



    ),

  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(model['id']);

  },
);

Widget buildTasksListView(
{
  @required List tasks,
}
    )=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) =>
      ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) =>
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 20.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],

                ),
              ),
          itemCount: tasks.length
      ),
  fallback: (context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/addtasks.png'),
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'You have a free day.',
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'Tap the + button to add some tasks.',
            ),
          ],
        ),
      ),

);