import 'package:flutter/material.dart';
import 'package:todo_list/component/TodoBox.dart';
import 'package:todo_list/component/textbox.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: const MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<TodoBox> todolist = [];

  void addTodo(String value, double size) {
    setState(() {
      todolist.add(TodoBox(size: size, todoText: value));
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todolist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            todolist =
                todolist.where((element) => element.isDone != true).toList();
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TodoInput(
                addTodo: addTodo,
                size: deviceWidth,
              ),
              ...todolist,
            ],
          )),
    );
  }
}
