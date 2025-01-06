import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MorningRoutine extends StatefulWidget {
  @override
  _MorningRoutineState createState() => _MorningRoutineState();
}

class _MorningRoutineState extends State<MorningRoutine> {
  final List<Map<String, dynamic>> _incompleteTasks = [];
  final List<Map<String, dynamic>> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? incompleteTasksString = prefs.getString('incompleteTasks');
    final String? completedTasksString = prefs.getString('completedTasks');

    if (incompleteTasksString != null) {
      setState(() {
        _incompleteTasks.addAll(List<Map<String, dynamic>>.from(json.decode(incompleteTasksString)));
      });
    }

    if (completedTasksString != null) {
      setState(() {
        _completedTasks.addAll(List<Map<String, dynamic>>.from(json.decode(completedTasksString)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('incompleteTasks', json.encode(_incompleteTasks));
    await prefs.setString('completedTasks', json.encode(_completedTasks));
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      final task = _incompleteTasks.removeAt(index);
      task['completed'] = true;
      _completedTasks.add(task);
      _saveTasks();
    });
  }

  void _toggleTaskIncompletion(int index) {
    setState(() {
      final task = _completedTasks.removeAt(index);
      task['completed'] = false;
      _incompleteTasks.add(task);
      _saveTasks();
    });
  }

  void _uncompleteAllTasks() {
    setState(() {
      for (var task in _completedTasks) {
        task['completed'] = false;
        _incompleteTasks.add(task);
      }
      _completedTasks.clear();
      _saveTasks();
    });
  }

  void _addTask(String taskName) {
    setState(() {
      _incompleteTasks.add({'name': taskName, 'completed': false});
      _saveTasks();
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Enter task name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addTask(taskController.text);
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
      appBar: AppBar(
        title: Text('Morning Routine'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _uncompleteAllTasks,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _incompleteTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _incompleteTasks[index]['completed'],
                    onChanged: (bool? value) {
                      _toggleTaskCompletion(index);
                    },
                  ),
                  title: Text(_incompleteTasks[index]['name']),
                );
              },
            ),
          ),
          Divider(),
          Text(
            'Completed Tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _completedTasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_completedTasks[index]['name']),
                  onDismissed: (direction) {
                    final task = _completedTasks[index];
                    _toggleTaskIncompletion(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task marked as incomplete'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _completedTasks.insert(index, task);
                              _incompleteTasks.remove(task);
                              task['completed'] = true;
                              _saveTasks();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: Checkbox(
                      value: _completedTasks[index]['completed'],
                      onChanged: (bool? value) {
                        _toggleTaskIncompletion(index);
                      },
                    ),
                    title: Text(
                      _completedTasks[index]['name'],
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}