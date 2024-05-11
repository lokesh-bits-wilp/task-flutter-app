import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_flutter_app/pre_auth/login_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final taskController = TextEditingController();
  DateTime? selectedDate; // Store selected due date

  void addTask() async {
    if (taskController.text.trim().isEmpty || selectedDate == null) {
      showError("Empty title or due date");
      return;
    }
    await saveTask(taskController.text, selectedDate!);
    setState(() {
      taskController.clear();
      selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restrict dates starting from today
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: logout,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        controller: taskController,
                        decoration: InputDecoration(
                          labelText: "New task",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      TextFormField(
                        readOnly: true, // Make it read-only
                        controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                        decoration: InputDecoration(
                          labelText: "Due Date (YYYY-MM-DD)",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: addTask,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 18.0, color: Colors.white), // Set text color here
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5.0,
                backgroundColor: Colors.blueAccent, // Set the background color here
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTask(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final varTask = snapshot.data![index];
                          final varTitle = varTask.get<String>('title')!;
                          final varDueDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(varTask.get<String>('dueDate')!));
                          final varDone = varTask.get<bool>('done')!;
                          return ListTile(
                            title: Text(varTitle),
                            subtitle: Text("Due Date: $varDueDate"),
                            leading: CircleAvatar(
                              child: Icon(varDone ? Icons.check : Icons.error),
                              backgroundColor: varDone ? Colors.green : Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: varDone,
                                  onChanged: (value) async {
                                    await updateTask(varTask.objectId!, value!);
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _editTask(varTask); // Call edit task function
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await deleteTask(varTask.objectId!);
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void logout() {
    _navigateToLoginScreen(context);
  }

  Future<void> saveTask(String title, DateTime dueDate) async {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate.toString())
      ..set('done', false);
    await task.save();
  }

  Future<List<ParseObject>> getTask() async {
    QueryBuilder<ParseObject> queryTask =
    QueryBuilder<ParseObject>(ParseObject('Task'));
    final ParseResponse apiResponse = await queryTask.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTask(String id, bool done) async {
    var task = ParseObject('Task')
      ..objectId = id
      ..set('done', done);
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    var task = ParseObject('Task')..objectId = id;
    await task.delete();
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTask(ParseObject task) {
    // Navigate to the edit task screen and pass the task object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final ParseObject task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.get<String>('title'));
    _dueDate = DateFormat('yyyy-MM-dd').parse(widget.task.get<String>('dueDate')!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Due Date: '),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showError("Empty title");
      return;
    }
    widget.task
      ..set('title', title)
      ..set('dueDate', _dueDate.toString());
    await widget.task.save();
    Navigator.pop(context);
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
