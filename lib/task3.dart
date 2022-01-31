import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task3 extends StatefulWidget {
  const Task3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Task3state();
}

class Task3state extends State<Task3> {
  @override
  Widget build(BuildContext context) {
    _drawerfuntion();
    _addnames(3);
    return Scaffold(
      appBar: AppBar(
        title: const Text('checkbox task'),
      ),
      body: Container(
          child: Column(
        children: [
          Text(
            'Names List',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Column(
            children: items,
          ),
          Text(
            'Fav List',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Column(children: fav),
        ],
      )),
    );
  }

  List<bool> names = [false, false, false];
  List<Widget> fav = [];
  bool checked = false;
  Widget _drawerfuntion() {
    Widget? widget;

    widget = ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: items,
          );
        });
    return widget!;
  }

  void onChanged(int index, bool? value) {
    if (value == true) {
      names[index] = value!;
      fav.add(_addtofav(index));
      items.removeAt(index);
    } else {
      names[index] = value!;
      items.add(fav[index]);
      fav.removeAt(index);
    }
    setState(() {});
  }

  List<Widget> items = [];
  void _addnames(int n) {
    items.clear();
    for (int i = 0; i < n; i++) {
      items.add(
        CheckboxListTile(
          title: Text('name $i'),
          subtitle: Text('description'),
          value: names[i],
          onChanged: (value) => onChanged(i, value),
        ),
      );
    }
  }

  Widget _addtofav(int i) {
    return CheckboxListTile(
      title: Text('name $i'),
      subtitle: Text('description'),
      value: false,
      onChanged: (value) => onChanged(i, value),
    );
  }
}
