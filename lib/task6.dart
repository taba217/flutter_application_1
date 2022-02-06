import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

// ./ngrok authtoken 24gYqF79JJYG8qJbIztzNAjlbrA_4KJVZ1StwBQEwCo8C4zXg

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Blogstate();
}

class Blogstate extends State<Blog> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  Future<Post>? _futurePost;
  late Service service;
  @override
  void initState() {
    service = Service();
    _futurePost = service.getPost(12);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _futurePosts;
    return MaterialApp(
      title: 'Blog Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Blog'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Post>>(
            builder: (context, snapshot) => _buildWidget1(context, snapshot),
            future: service.getPosts(),
          ),
          // (_futurePost == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  FutureBuilder<Post> buildFutureBuilder() {
    return FutureBuilder<Post>(
      future: _futurePost,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Post post = snapshot.data!;
          final title = post.title;
          return Text(post.id.toString() + " " + title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        TextField(
          controller: _controller1,
          decoration: const InputDecoration(hintText: 'Enter Body'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                // _futurePost = serv createPost(_controller.text);
              });
            },
            child: const Text('Create Data'),
          ),
        ),
      ],
    );
  }
}

Widget _buildWidget(context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasData) {
      Post post = snapshot.data!;
      return Text(post.title);
    } else {
      return Text(snapshot.error.toString());
    }
  }
  return const CircularProgressIndicator();
}

Widget _buildWidget1(context, AsyncSnapshot<List<Post>> snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasData) {
      List<Post> posts = snapshot.data!;
      return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Text(posts[index].title);
          });
    } else {
      return Text(snapshot.error.toString());
    }
  }
  return const CircularProgressIndicator();
}

abstract class Api {
  Future<Post> getPost(int id);
  Future<Post> createPost(String title, String body);
  Future<Post> updatePost(String title, String body);
  Future<Post> deletePost(int id);
  Future<List<Post>> getPosts();
}

class Service implements Api {
  final String _url = 'https://jsonplaceholder.typicode.com/posts/';
  String _path = 'posts/';
  @override
  Future<Post> getPost(int id) async {
    Response response = await get(Uri.parse('$_url$id'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('error');
    }
  }

  @override
  Future<Post> createPost(String title, String body) async {
    final response = await post(
      Uri.parse('$_url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Post. ${response.request}');
    }
  }

  @override
  Future<Post> deletePost(int id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() async {
    Response response = await get(Uri.parse('$_url'));
    if (response.statusCode == 200) {
      String body = response.body;
      Iterable jsonMap = jsonDecode(body);
      return List<Post>.from(jsonMap.map((e) => Post.fromJson(e)));
    } else {
      throw ("Error retrieving posts");
    }
  }

  @override
  Future<Post> updatePost(String title, String body) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
