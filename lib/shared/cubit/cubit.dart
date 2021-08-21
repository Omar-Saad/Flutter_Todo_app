import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState>{

  int currentIndex=0;
  Database database;
  List<Widget> screens =
  [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> title =
  [
    'New Tasks',
    'Done Tasks',
    'Archived tasks'
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  AppCubit() : super(AppInitialState());

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.add;

  static AppCubit get(context) => BlocProvider.of(context);

  void cahngeBottomNavIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }


  void changeBottomSheetState({
  @required bool isShown,
    @required IconData icon,
}){
    isBottomSheetShown = isShown;
    fabIcon =icon;
    emit(AppChangeBottomNavState());
  }

  createDatabase() async{
    print('DATABASE CREATED');

    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version) {
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('TABLE CREATED');
          }).catchError((error){
            print('ERROR CREATING DATABASE');

          });
        },
        onOpen: (database){
          print('DATABASE OPENED');
          getFromDatabase(database);
        }
    ).then((value) {
      database = value;
      emit(AppCraeteDatabaseState());
    });
  }

   insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.rawInsert(
        'INSERT INTO tasks (title,date,time,status) VALUES ("$title","$date","$time","new")'
    ).then((value){
      print('$value Inserted successfully');
      emit(AppInsertToDatabaseState());

        getFromDatabase(database);

    }).catchError((error){
      print('Error in insertion');
    });
  }

 void getFromDatabase(Database database) {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    emit(AppDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
     // tasks = value;
     // print(tasks);
      emit(AppGetDatabaseState());
      value.forEach((element) {
        if(element['status']=='new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else if(element['status'] == 'archived')
          archivedTasks.add(element);
      });
    });
  }

  void updateData(
      @required int id,
      @required String status
      ) async{
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id'])
     .then((value) {
       getFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });

  }

  void deleteData(
      @required int id,
      ) async{
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        ['$id'])
        .then((value) {
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });

  }
}