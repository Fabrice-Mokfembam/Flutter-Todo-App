import 'package:flutter/material.dart';
import 'package:todo_app/pages/todos_page.dart';
import 'package:todo_app/pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: WelcomePage(),
     routes: {
      "/WelcomePage": (context)=>const  WelcomePage(),
      "/TodosPage":(context) =>  TodosPage(),
     },
    );
  }
}
