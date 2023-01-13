import 'package:todolist/model/todo.dart';

abstract class DbState {
  List<ToDo> todos = [];
}

class DatabaseInitial implements DbState {
  @override
  List<ToDo> todos = [];
}

class DatabaseLoading implements DbState {
  @override
  List<ToDo> todos = [];
}

class DatabaseError implements DbState {
  @override
  List<ToDo> todos = [];
}

class DatabaseLoaded implements DbState {
  @override
  List<ToDo> todos;
  DatabaseLoaded({required this.todos});
}
