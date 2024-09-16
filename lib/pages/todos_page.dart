import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodosPage extends StatefulWidget {
  TodosPage({super.key});

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  List<dynamic> todos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/getAll/todos'));

    if (response.statusCode == 200) {
      setState(() {
        todos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> _addTodo(String task) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/create/todo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "task": task,
        "is_completed": false,
      }),
    );

    if (response.statusCode == 201) {
      _fetchTodos();
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> _deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/delete/todo/$id'),
    );

    if (response.statusCode == 200) {
      _fetchTodos();
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  Future<void> _updateTodo(String id, String updatedTask) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/update/todo/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "task": updatedTask,
      }),
    );

    if (response.statusCode == 200) {
      _fetchTodos();
    } else {
      throw Exception('Failed to update todo');
    }
  }

  void _showTodoDialog({String? id, String? initialTask}) {
    String newTask = initialTask ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? "Add New Task" : "Edit Task"),
          content: TextField(
            controller: TextEditingController(text: newTask),
            onChanged: (value) {
              newTask = value;
            },
            decoration: const InputDecoration(hintText: "Enter task"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  if (id == null) {
                    _addTodo(newTask);
                  } else {
                    _updateTodo(id, newTask);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 13, 14),
          title: const Center(
            child: Text(
              "My Todos",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        todo['task'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showTodoDialog(
                                  id: todo['id'].toString(),
                                  initialTask: todo['task']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteTodo(todo['id'].toString());
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showTodoDialog();
          },
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }
}
