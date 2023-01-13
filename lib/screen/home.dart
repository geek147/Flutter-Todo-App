import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist/bloc/db_bloc.dart';
import 'package:todolist/bloc/db_state.dart';
import 'package:todolist/model/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DbBloc? databaseBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = '', description = '';
  @override
  void initState() {
    super.initState();
    databaseBloc = BlocProvider.of<DbBloc>(context);
    databaseBloc?.onFetch();
  }

  @override
  void dispose() {
    super.dispose();
    databaseBloc?.close();
  }

  void createATodo(String title, String description) {
    ToDo todo = ToDo(title: title, desc: description);
    databaseBloc?.onCreate(todo);
  }

  void deleteATodo(ToDo todo) {
    databaseBloc?.onDelete(todo);
  }

  void showDeleteDialog(ToDo todo) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteATodo(todo);
                Fluttertoast.showToast(msg: 'Todo is deleted!');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showInputDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        double customHeight = MediaQuery.of(context).size.height * .3;
        double customWidth = MediaQuery.of(context).size.width * .5;
        int maxTitleLength = 128, maxDescriptionLength = 256;

        return AlertDialog(
          title: const Text('Add a new todo'),
          content: SizedBox(
            height: customHeight,
            width: customWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: maxTitleLength,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                    validator: (String? value) {
                      if (value?.trim() == '') {
                        return 'Title should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      title = value ?? '';
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: maxDescriptionLength,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                    validator: (String? value) {
                      return null;
                    },
                    onSaved: (String? value) {
                      description = value ?? '';
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState?.save();
                createATodo(title, description);
                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Todo is added successfully!');
              },
            ),
          ],
        );
      },
    );
  }

  void updateToDoStatus(ToDo todo) {
    databaseBloc?.onUpdate(todo);

    Fluttertoast.showToast(
        msg: todo.status == 0 ? 'Marked as Completed!' : 'Undone todo!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showInputDialog,
          ),
        ],
      ),
      body: BlocConsumer<DbBloc, DbState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is DatabaseLoaded
              ? ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (_, idx) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: ((context) {
                              updateToDoStatus(state.todos[idx]);
                            }),
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.mark_chat_read,
                            label: 'Mark as Done',
                          ),
                          SlidableAction(
                            onPressed: ((context) {
                              updateToDoStatus(state.todos[idx]);
                            }),
                            backgroundColor: const Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.cancel,
                            label: 'Cancel',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: ((context) {
                              showDeleteDialog(
                                state.todos[idx],
                              );
                            }),
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            state.todos[idx].title,
                            style: TextStyle(
                              decoration: state.todos[idx].status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          subtitle: Text(
                            state.todos[idx].desc,
                            style: TextStyle(
                              decoration: state.todos[idx].status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Empty todo list.'),
                );
        },
      ),
    );
  }
}
