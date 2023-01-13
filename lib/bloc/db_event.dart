import 'package:todolist/model/todo.dart';

class DbEvent {}

class CreateToDo extends DbEvent {
  ToDo todo;
  CreateToDo({required this.todo});
}

class FetchToDo extends DbEvent {}

class UpdateToDo extends DbEvent {
  ToDo todo;
  UpdateToDo({required this.todo});
}

class DeleteToDo extends DbEvent {
  ToDo todo;
  DeleteToDo({required this.todo});
}

class ClearToDo extends DbEvent {}
