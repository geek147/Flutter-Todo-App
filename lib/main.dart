import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/db_bloc.dart';
import 'package:todolist/bloc/db_state.dart';
import 'package:todolist/screen/home.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: BlocProvider(
        create: (_) => DbBloc(),
        child: const Home(),
      ),
    );
  }
}
