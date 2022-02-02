import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

class Task4 extends StatefulWidget {
  const Task4({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Task4state();
}

Future<Post> getPost() async {
  JsonPlaceHolder jsonPlaceHolder = JsonPlaceHolder();
  Response response = await jsonPlaceHolder.getPost(1);
  if (response.statusCode == 200) {
    body = response.body;
    Map<String, dynamic> map = jsonDecode(body);
    return Post.fromjson(map);
  } else {
    throw ('Error');
  }
}

late Future<Post> post;
String body = '';

abstract class Api {
  Future<Response> getPost(int id);
}

class JsonPlaceHolder implements Api {
  String url = 'https://jsonplaceholder.typicode.com/';
  String path = 'posts/2';
  Map<String, String> headers = {
    'content-type': 'Application/json;charset=utf-8'
  };
  @override
  Future<Response> getPost(int id) async {
    return await get(Uri.parse('$url$path'), headers: headers);
  }
}

class Post {
  int userId;
  int id;
  String title;
  String body;
  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
  factory Post.fromjson(Map<String, dynamic> json) {
    return Post(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        body: json['body'] as String);
  }
}

class Task4state extends State<Task4> {
  @override
  void initState() {
    post = getPost();
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
          future: post,
          builder: (context, AsyncSnapshot<Post> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasData) {
                  Post myPost = snapshot.data!;

                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(myPost.title),
                    ),
                    subtitle: Expanded(child: Text(myPost.body)),
                  );
                } else {
                  return Text(snapshot.error.toString());
                }
            }
          },
        ),
      ),
      // body: Center(
      //   child: FutureBuilder(
      //     future: post,
      //     builder: (context, AsyncSnapshot<Post> snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //         case ConnectionState.waiting:
      //         case ConnectionState.active:
      //           return const CircularProgressIndicator();
      //         default:
      //           if (snapshot.hasData) {
      //             Post mypost = snapshot.data!;
      //             return ListTile(
      //               title: Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text(mypost.title),
      //               ),
      //               subtitle: Expanded(
      //                 child: Text(mypost.body),
      //               ),
      //             );
      //           } else {
      //             Text(snapshot.error.toString());
      //           }
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
