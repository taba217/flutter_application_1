import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/task6.dart';

class Updateform extends StatefulWidget {
  const Updateform({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Updateformstate();
}

late Service service;
late Post post;

class Updateformstate extends State<Updateform> {
  late Future<Post> _futurePost;
  late Post post;
  late Map arguments;

  @override
  void initState() {
    service = Service();
    Future.delayed(Duration.zero, () {
      setState(() {
        arguments = ModalRoute.of(context)!.settings.arguments as Map;
      });
      _futurePost = service.getPost(arguments['postid']);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Form'),
      ),
      body: Center(child: _formOptions(arguments['formid'])),
    );
  }

  Widget _formOptions(int i) {
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller1 = TextEditingController();
    switch (i) {
      case 1:
        return FutureBuilder<Post>(
          future: _futurePost,
          builder: (context, AsyncSnapshot<Post> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              post = snapshot.data!;
              return Container(
                margin: EdgeInsets.all(8),
                child: Card(
                  elevation: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            post.title,
                            // style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            post.body,
                            // style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(12),
                              padding: EdgeInsets.all(8),
                              height: 50,
                              child: Text(
                                'Update Fields',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter New Title'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _controller1,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter New Body'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _futurePost = service.updatePost(
                                        arguments['postid'],
                                        _controller.text,
                                        _controller1.text);
                                    // print(
                                    //     '$post.id, $_controller.text$_controller1.text');
                                  });
                                },
                                child: const Text('Update Data'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator(); //Text(snapshot.error.toString());
            }
          },
        );
      case 2:
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Enter Title'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(hintText: 'Enter Body'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futurePost = service.createPost(
                          _controller.text, _controller1.text);
                    });
                  },
                  child: const Text('Create Data'),
                ),
              ),
            ],
          ),
        );

      default:
        return CircularProgressIndicator();
    }
  }
}
