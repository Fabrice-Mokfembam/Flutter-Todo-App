import 'package:flutter/material.dart';

class TodosPage extends StatelessWidget {
  TodosPage({super.key});

  final List<String> todos = [
    'First Todo',
    'Second Todo',
    'Third Todo',
    'Fourth Todo',
    'Fifth Todo',
    'Sixth Todo',
    'Seventh Todo',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 108, 83, 248),
            title: const Center(
              child: Text(
                "My Todos",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          body: ListView.builder(
              padding: EdgeInsets.all(20.0),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Card(
                     
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                        title: Text(
                          todos[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            
                          },
                        )));
              }),
        ));
  }
}
