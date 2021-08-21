import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController=TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppState>(
        builder: (BuildContext context, state) {
          AppCubit cubit  = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition: state is! AppDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                  }
                }
                else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) =>
                        Container(

                          padding: EdgeInsets.all(20.0,),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defautltTextFormFiels(
                                    keyboardType: TextInputType.text,
                                    labelText: 'Task Title',
                                    validtor: (String value) {
                                      if (value.isEmpty)
                                        return 'Required Field';
                                      return null;
                                    },
                                    prefixIcon: Icons.title,
                                    controller: titleController),
                                SizedBox(
                                  height: 16.0,
                                ),
                                defautltTextFormFiels(
                                    keyboardType: TextInputType.datetime,
                                    labelText: 'Task Time',
                                    isReadOnly: true,
                                    validtor: (String value) {
                                      if (value.isEmpty)
                                        return 'Required Field';
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value.format(context)
                                                .toString();
                                      });
                                    },
                                    prefixIcon: Icons.watch_later_outlined,
                                    controller: timeController),
                                SizedBox(
                                  height: 16.0,
                                ),
                                defautltTextFormFiels(
                                    keyboardType: TextInputType.datetime,
                                    labelText: 'Task Date',
                                    isReadOnly: true,
                                    validtor: (String value) {
                                      if (value.isEmpty)
                                        return 'Required Field';
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse(
                                              '3000-09-16'))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(value).toString();
                                      });
                                    },
                                    prefixIcon: Icons.calendar_today_outlined,
                                    controller: dateController),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0,)
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(isShown: false, icon: Icons.add);

                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.save_alt);

                }
              },
              child: Icon(
                cubit.fabIcon,
              ),

            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.cahngeBottomNavIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_outlined,
                  ),
                  label: 'Tasks',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',

                ),

              ],

            ),
          );

        },
        listener: (BuildContext context, state) {
          if(state is AppInsertToDatabaseState)
          Navigator.pop(context);
        },

      ),
    );
  }


}

