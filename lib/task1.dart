import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _sendindexvaltocounter(int index) {
    setState(() {
      _counter = index;
      print(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
            child: const Icon(Icons.exit_to_app),
            // margin: const EdgeInsets.only(right: 50.0),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'this app will type the index of selected nav child',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              _counter.toString(),
              style: Theme.of(context).textTheme.headline5,
            ),
            // TextButton(onPressed: onPressed, child: child)
            TextButton.icon(
                onPressed: () {
                  _counter = 1000;
                  setState(() {
                    
                  });
                },
                icon: const Icon(Icons.smart_button),
                label: const Text('max counter value'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                  onPressed: () {
                    _sendindexvaltocounter(1);
                  },
                  child: Icon(Icons.home)),
              Text("home")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                  onPressed: () {
                    _sendindexvaltocounter(2);
                  },
                  child: Icon(Icons.library_add)),
              Text("lib")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                  onPressed: () {
                    _sendindexvaltocounter(3);
                  },
                  child: const Icon(Icons.music_note_sharp)),
              const Text("sounds")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                  onPressed: () {
                    _sendindexvaltocounter(4);
                  },
                  child: const Icon(Icons.video_call_sharp)),
              const Text("videos")
            ],
          ),
        ],
        onDestinationSelected: _sendindexvaltocounter,
      ),
      backgroundColor: Colors.blueGrey,
      drawer: Drawer(
        semanticLabel: "BestApp",
        backgroundColor: Colors.brown,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.adjust_sharp),
            const Spacer(
              flex: 10,
            ),
            const Text("click here"),
            Spacer(),
            const Text("data"),
            Spacer(),
            Row(
              children: const [
                Icon(Icons.shop_2),
                Text('text inside row'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
