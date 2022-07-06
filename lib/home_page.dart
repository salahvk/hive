import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/task_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String inputTask;
  late Task _task;
  Box<Task>? todosBox;

  void _addTodo(Task inputTodo) {
    todosBox!.add(Task(task: inputTodo.task));
  }

  @override
  Widget build(BuildContext context) {
    // notesBox.clear();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple TODO app using Hive'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Task>('TODOs').listenable(),
          builder: (context, Box<Task> notesBox, _) {
            todosBox = notesBox;
            return ListView.builder(
                itemCount: notesBox.values.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todosBox!.getAt(index);
                  return ListTile(
                    title: Text(todo!.task),
                    onLongPress: () => todosBox!.deleteAt(index),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _simpleDialog(),
        tooltip: 'AddNewTODOTask',
        child: const Icon(Icons.add),
      ),
    );
  }

  _simpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('New TODO Task'),
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'TODO Task',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => inputTask = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _task = Task(task: inputTask);
                              print(_task);
                              _addTodo(_task);
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // remove the deleted index holes/slots from database
    // to free up the space
    todosBox!.compact();

    todosBox!.close();
    super.dispose();
  }
}
