import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MorningRoutine extends StatefulWidget {
  @override
  _MorningRoutineState createState() => _MorningRoutineState();
}

class _MorningRoutineState extends State<MorningRoutine> {
  final List<Map<String, dynamic>> _incompleteTasks = [];
  final List<Map<String, dynamic>> _completedTasks = [];
  Color _backgroundColor = Colors.white;
  File? _backgroundImage;
  final ImagePicker _picker = ImagePicker();
  List<bool> _isExpandedList = [true];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadBackgroundColor();
    _loadBackgroundImage();
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

  Future<void> _loadBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    final int? colorValue = prefs.getInt('backgroundColor');
    if (colorValue != null) {
      setState(() {
        _backgroundColor = Color(colorValue);
      });
    }
  }

  Future<void> _saveBackgroundColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('backgroundColor', color.value);
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('backgroundImage');
    if (imagePath != null) {
      setState(() {
        _backgroundImage = File(imagePath);
      });
    }
  }

  Future<void> _saveBackgroundImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundImage', path);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _backgroundImage = File(pickedFile.path);
        _saveBackgroundImage(pickedFile.path);
      });
    }
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

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Background Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _backgroundColor,
              onColorChanged: (Color color) {
                setState(() {
                  _backgroundColor = color;
                  _saveBackgroundColor(color);
                });
                Navigator.of(context).pop();
              },
              availableColors: [
                Colors.white,
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
                Colors.pink,
                Colors.brown,
                Colors.grey,
                Colors.black,
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Background Image'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _backgroundImage = null;
                      _saveBackgroundImage('');
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Remove Image'),
                ),
                // Add more buttons for selecting images from assets if needed
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
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
            icon: Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Undo') {
                _uncompleteAllTasks();
              } else if (result == 'Theme') {
                _showThemeDialog();
              } else if (result == 'Image') {
                _showImagePickerDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Undo',
                child: Text('Undo All Tasks'),
              ),
              const PopupMenuItem<String>(
                value: 'Theme',
                child: Text('Theme'),
              ),
              const PopupMenuItem<String>(
                value: 'Image',
                child: Text('Background Image'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          image: _backgroundImage != null
              ? DecorationImage(
                  image: FileImage(_backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpandedList[index] = !isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            'Completed Tasks',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      body: Column(
                        children: _completedTasks.map((task) {
                          int index = _completedTasks.indexOf(task);
                          return Dismissible(
                            key: Key('${task['name']}_$index'),
                            onDismissed: (direction) {
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
                                value: task['completed'],
                                onChanged: (bool? value) {
                                  _toggleTaskIncompletion(index);
                                },
                              ),
                              title: Text(
                                task['name'],
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      isExpanded: _isExpandedList[0],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}