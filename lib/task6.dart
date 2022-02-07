import 'dart:convert';
import 'package:flutter_application_1/task6%20form.dart' as updateform;
import 'package:http/http.dart';
import 'package:flutter/material.dart';

// ./ngrok authtoken 24gYqF79JJYG8qJbIztzNAjlbrA_4KJVZ1StwBQEwCo8C4zXg

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Blogstate();
}

late Service service;

class Blogstate extends State<Blog> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  Future<Post>? _futurePost;

  @override
  void initState() {
    service = Service();

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(
                      arguments: {'formid': 2},
                    ),
                    builder: (context) => const updateform.Updateform()));
          },
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
          clipBehavior: Clip.hardEdge,
          controller: ScrollController(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14)),
                      child: Card(
                          child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(
                              posts[index].title,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              posts[index].body,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            dense: true,
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text("Update"),
                                  value: 1,
                                ),
                                const PopupMenuItem(
                                  child: Text("delete"),
                                  value: 2,
                                )
                              ],
                              onSelected: (value) => {
                                if (value == 1)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            settings: RouteSettings(
                                              arguments: {
                                                'formid': value,
                                                'postid':
                                                    snapshot.data![index].id
                                              },
                                            ),
                                            builder: (context) =>
                                                const updateform.Updateform())),
                                  }
                                else
                                  {service}
                              },
                            ),
                          ),
                        ),
                      ))),
                ],
              ),
            );
          });
    } else {
      return Text(snapshot.error.toString());
    }
  }
  return const CircularProgressIndicator();
}

late Map<String, String> _headers;

abstract class Api {
  Future<Post> getPost(int id);
  Future<Post> createPost(String title, String body);
  Future<Post> updatePost(int id, String title, String body);
  Future<Post> deletePost(int id);
  Future<List<Post>> getPosts();
}

class Service implements Api {
  final String _url = 'https://jsonplaceholder.typicode.com/posts/';
  String _path = 'posts/';
  final _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
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
      headers: _headers,
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
  Future<Post> updatePost(int id, String title, String body) async {
    Response response = await put(
      Uri.parse('$_url$id'),
      headers: _headers,
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );
    if (response.statusCode == 200) {
      String body = response.body;
      return Post.fromJson(jsonDecode(body));
    } else {
      throw ("Error retrieving posts");
    }
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
