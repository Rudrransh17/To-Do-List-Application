import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todoey_flutter/tasks_list.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  TextEditingController controller = TextEditingController();

  _toggleItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  _addItem(String title) {
    setState(() {
      final item = TodoItem(title: title, done: false, date: DateTime.now());
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  _deleteItem(String title) async {
    await storage.deleteItem(title);
    setState(() {});
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('todos') ?? [];
      Navigator.pop(context);
    });
  }

  void _save() {
    if (controller.text.isEmpty) {
      controller.text = 'New Task';
    }
    _addItem(controller.value.text);
    controller.clear();
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context, TodoItem item) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: item.date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != item.date) {
      Navigator.of(context).pop();
      setState(() {
        item.date = picked;
      });
    }
  }

  String _returnDate(DateTime date) {
    String day = '';
    String month = '';
    if (date.day < 10) {
      day = '0${date.day}';
    } else {
      day = '${date.day}';
    }
    switch (date.month) {
      case 1:
        {
          month = 'Jan';
        }
        break;
      case 2:
        {
          month = 'Feb';
        }
        break;
      case 3:
        {
          month = 'Mar';
        }
        break;
      case 4:
        {
          month = 'Apr';
        }
        break;
      case 5:
        {
          month = 'May';
        }
        break;
      case 6:
        {
          month = 'Jun';
        }
        break;
      case 7:
        {
          month = 'Jul';
        }
        break;
      case 8:
        {
          month = 'Aug';
        }
        break;
      case 9:
        {
          month = 'Sep';
        }
        break;
      case 10:
        {
          month = 'Oct';
        }
        break;
      case 11:
        {
          month = 'Nov';
        }
        break;
      case 12:
        {
          month = 'Dec';
        }
        break;
    }
    return '$day $month';
  }

  showAlertDialog(
      BuildContext context, String title, String date, TodoItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: [
              const Text('Due date  '),
              const Expanded(
                child: SizedBox(),
              ),
              Text(
                _returnDate(item.date),
              ),
              IconButton(
                onPressed: () {
                  _selectDate(context, item);
                },
                icon: const Icon(Icons.calendar_today_outlined),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete Task"),
              onPressed: () {
                _deleteItem(title);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Mark Completed"),
              onPressed: () {
                _toggleItem(item);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: const Color(0xff757575),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Add Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'What to do?',
                          ),
                          onEditingComplete: _save,
                        ),
                        // Container(
                        //   child: Row(
                        //     children: [
                        //       Text('Due Date'),
                        //       IconButton(
                        //         onPressed: _selectDate(
                        //           context,
                        //         ),
                        //         icon: const Icon(Icons.calendar_today_outlined),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: <Widget>[
                        //     IconButton(
                        //       icon: const Icon(Icons.save),
                        //       onPressed: _save,
                        //       tooltip: 'Save',
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.delete),
                        //       onPressed: _clearStorage,
                        //       tooltip: 'Clear storage',
                        //     )
                        //   ],
                        // ),
                        // TextField(
                        //   autofocus: true,
                        //   textAlign: TextAlign.center,
                        //   onChanged: (taskValue) {
                        //     newTask = taskValue;
                        //   },
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.lightBlueAccent, // Background Color
                          ),
                          onPressed: _save,
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _clearStorage,
                          child: const Text(
                            'Clear List',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'To-Do List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${list.items.length} Task',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: FutureBuilder(
                future: storage.ready,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!initialized) {
                    var items = storage.getItem('todos');

                    if (items != null) {
                      list.items = List<TodoItem>.from(
                        (items as List).map(
                          (item) => TodoItem(
                            title: item['title'],
                            done: item['done'],
                            date: DateFormat("yyyy-MM-dd hh:mm:ss")
                                .parse(item['date']),
                          ),
                        ),
                      );
                    }

                    initialized = true;
                  }

                  List<Widget> widgets = list.items.map((item) {
                    return ListTile(
                      subtitle: Text('Due ${_returnDate(item.date)}'),
                      title: item.done == true
                          ? Text(
                              item.title,
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Text(item.title),
                      selected: item.done,
                      onLongPress: () => showAlertDialog(
                          context, item.title, _returnDate(item.date), item),
                      trailing: Checkbox(
                        value: item.done,
                        onChanged: (_) {
                          _toggleItem(item);
                        },
                      ),
                    );
                    // CheckboxListTile(
                    //   value: item.done,
                    //   subtitle: GestureDetector(
                    //     onLongPress: () => showAlertDialog,
                    //     child: Text('Due ${_returnDate(item.date)}'),
                    //   ),
                    //   title: item.done == true
                    //       ? Text(
                    //           item.title,
                    //           style: const TextStyle(
                    //               decoration: TextDecoration.lineThrough),
                    //         )
                    //       : Text(item.title),
                    //   selected: item.done,
                    //   onChanged: (_) {
                    //     _toggleItem(item);
                    //   },
                    // );
                  }).toList();

                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ListView(
                          children: widgets,
                          itemExtent: 50.0,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ListTile(
//   title: TextField(
//     controller: controller,
//     decoration: const InputDecoration(
//       labelText: 'What to do?',
//     ),
//     onEditingComplete: _save,
//   ),
//   trailing: Row(
//     mainAxisSize: MainAxisSize.min,
//     children: <Widget>[
//       IconButton(
//         icon: const Icon(Icons.save),
//         onPressed: _save,
//         tooltip: 'Save',
//       ),
//       IconButton(
//         icon: const Icon(Icons.delete),
//         onPressed: _clearStorage,
//         tooltip: 'Clear storage',
//       )
//     ],
//   ),
// ),
