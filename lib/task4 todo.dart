import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

class Task4todo extends StatefulWidget {
  const Task4todo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Task4todostate();
}

Future<Todo> gettodo() async {
  JsonPlaceHolder jsonPlaceHolder = JsonPlaceHolder();
  Response response = await jsonPlaceHolder.gettodo(1);
  if (response.statusCode == 200) {
    body = response.body;
    Map<String, dynamic> map = jsonDecode(body);
    return Todo.fromjson(map);
  } else {
    throw ('Error');
  }
}

late Future<Todo> todo;
String body = '';

abstract class Api {
  Future<Response> gettodo(int id);
}

class JsonPlaceHolder implements Api {
  String url = 'https://jsonplaceholder.typicode.com/';
  String path = 'todos/2';
  Map<String, String> headers = {
    'content-type': 'Application/json;charset=utf-8'
  };
  @override
  Future<Response> gettodo(int id) async {
    return await get(Uri.parse('$url$path'), headers: headers);
  }
}

class Todo {
  int userId;
  int id;
  String title;
  bool completed;
  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });
  factory Todo.fromjson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        completed: json['completed'] as bool);
  }
}

class Task4todostate extends State<Task4todo> {
  @override
  void initState() {
    todo = gettodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('getdata task'),
      ),
      body: Container(
        child: FutureBuilder(
          future: todo,
          builder: (context, AsyncSnapshot<Todo> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasData) {
                  Todo mytodo = snapshot.data!;
                  return CheckboxListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(mytodo.title),
                    ),
                    onChanged: (bool? value) {},
                    value: mytodo.completed,
                  );
                } else {
                  return Text(snapshot.error.toString());
                }
            }
          },
        ),
      ),
    );
  }
}
