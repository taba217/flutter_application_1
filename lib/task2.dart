import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task2 extends StatefulWidget {
  const Task2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Task2state();
}

class Task2state extends State<Task2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('square task'),
      ),
      body: Center(child: _drawerfuntion()),
    );
  }

  Widget _drawerfuntion() {
    var n = 8;
    Widget sqr;
    sqr = Column(
      children: <Widget>[
        // ignore: unrelated_type_equality_checks
        for (int j = 0; j < (n / 2) != 3; j++)
          Center(
            child: Row(
              children: [
                for (int i = 0; i < n / 2; i++)
                  Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        // color: Colors.red,
                        child: Text('   bbbn ffff '),
                      ),
                    ],
                  )
              ],
            ),
          ),
      ],
    );
    setState(() {});
    return sqr;
  }
}
