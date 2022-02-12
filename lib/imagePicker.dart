import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/task6.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class imageEx extends StatefulWidget {
  const imageEx({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => imageExstate();
}

late Service service;

class imageExstate extends State<imageEx> {
  final TextEditingController _controller = TextEditingController();

  Future<User>? _future;

  String? _pickImageError;

  XFile? _imageFile;
  XFile? _backImage;

  bool isitback = false;

  @override
  void initState() {
    service = new Service();
    _future = service.getObject(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profiles')),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          isitback = true;
                          _pickImage(ImageSource.gallery);
                        },
                        child: Text('Edit'),
                      )
                    ],
                  ),
                  _ProfilePage(),
                ],
              ),
            ),
            FutureBuilder(
              future: _future,
              builder: (centext, AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    User user = snapshot.data!;
                    return Column(
                      children: [
                        Container(
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text('name : ' + user.name),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text('username : ' + user.username),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text('website : ' + user.website),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text('email : ' + user.email),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text('name : ' + user.name),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(snapshot.error.toString());
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showDialog();
          _pickImage(ImageSource.gallery);
        },
        child: Icon(Icons.image),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        routeSettings: RouteSettings(),
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  ImagePicker? _picker;
  void _pickImage(ImageSource source) async {
    _picker = new ImagePicker();
    try {
      final pickedFile = await _picker!.pickImage(
        source: source,
      );
      setState(() {
        if (isitback) {
          isitback = false;
          _backImage = pickedFile;
        } else {
          _imageFile = pickedFile;
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e.toString();
      });
    }
    // Navigator.of(context).pop();
  }

  Widget _ProfilePage() {
    Picker pick = new Picker();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                _backImage == null ? 'image place' : _backImage!.path,
              ),
              fit: BoxFit.cover)),
      child: Center(
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(50.0),
          decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.black,
              ),
              shape: BoxShape.circle),
          child: Semantics(
            label: 'image_picker_example_picked_image',
            child: _imageFile == null
                ? Text('image place')
                : Image.network(_imageFile!.path),
            // : Image.file(File(_imageFileList![index].path)),
          ),
        ),
      ),
    );
  }
}

class Picker {}

class User {
  final int id;
  final String name;
  final String username;
  final String website;
  final String email;

  User(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.website});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      website: json['website'],
    );
  }
}

abstract class Api {
  Future<Object> getObject(int id);
  // Future<Object> createObject(String title, String body);
  Future<Object> updateObject(int id, String website, String email);
  // Future<String> deleteObject(int id);
  // Future<List<Object>> getObjects();
}

class Service implements Api {
  final String _url = 'https://jsonplaceholder.typicode.com/users/';
  String _path = 'Objects/';
  final _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
  @override
  Future<User> getObject(int id) async {
    Response response = await get(Uri.parse('$_url$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('error');
    }
  }

  @override
  Future<List<User>> getObjects() async {
    Response response = await get(Uri.parse('$_url'));
    if (response.statusCode == 200) {
      String body = response.body;
      Iterable jsonMap = jsonDecode(body);
      return List<User>.from(jsonMap.map((e) => User.fromJson(e)));
    } else {
      throw ("Error retrieving Objects");
    }
  }

  @override
  Future<User> updateObject(int id, String website, String email) async {
    Response response = await put(
      Uri.parse('$_url$id'),
      headers: _headers,
      body: jsonEncode(<String, String>{
        'website': website,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      String body = response.body;
      return User.fromJson(jsonDecode(body));
    } else {
      throw ("Error retrieving Objects");
    }
  }
}
