import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todolist/bloc/db_event.dart';
import 'package:todolist/bloc/db_state.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/util/db_helper.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DatabaseInitial()) {
    on<CreateToDo>(
      (event, emit) async {
        emit(DatabaseLoading());
        await DbHelper.db.createToDo(event.todo);
        var result = await DbHelper.db.fetchAllToDo();
        emit(DatabaseLoaded(todos: result));
      },
    );

    on<FetchToDo>(
      (event, emit) async {
        var result = await DbHelper.db.fetchAllToDo();
        emit(DatabaseLoaded(todos: result));
      },
    );

    on<UpdateToDo>(
      (event, emit) async {
        emit(DatabaseLoading());
        await DbHelper.db.updateToDoStatus(event.todo);
        var result = await DbHelper.db.fetchAllToDo();
        emit(DatabaseLoaded(todos: result));
      },
    );

    on<DeleteToDo>(
      (event, emit) async {
        emit(DatabaseLoading());
        await DbHelper.db.deleteSingleToDo(event.todo);
        var result = await DbHelper.db.fetchAllToDo();
        emit(DatabaseLoaded(todos: result));
      },
    );

    on<ClearToDo>(
      (event, emit) async {
        emit(DatabaseLoading());
        await DbHelper.db.clearTodoTable();
        var result = await DbHelper.db.fetchAllToDo();
        emit(DatabaseLoaded(todos: result));
      },
    );
  }

  void onCreate(ToDo todo) {
    add(
      CreateToDo(todo: todo),
    );
  }

  void onFetch() {
    add(
      FetchToDo(),
    );
  }

  void onUpdate(ToDo todo) {
    add(
      UpdateToDo(todo: todo),
    );
  }

  void onDelete(ToDo todo) {
    add(
      DeleteToDo(todo: todo),
    );
  }

  void onClear() {
    add(
      ClearToDo(),
    );
  }
}
