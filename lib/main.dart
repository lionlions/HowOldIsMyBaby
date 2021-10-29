import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:developer';
import 'add_baby_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'How old is my baby'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: Get data from DB
  }

  @override
  Widget build(BuildContext context) {
    void _addBabyInfoPage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return const AddBabyInfo();
      })).then((needToUpdate) {
        if(needToUpdate){
          setState(() {
            debugPrint("update layout");
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text("list is empty"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBabyInfoPage,
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

// List<Widget> _buildRow() {
//   final tiles = _suggestions.map((WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(pair.asPascalCase, style: _biggerFont),
//       trailing: Icon(
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   });
//   return ListTile.divideTiles(
//     context: context,
//     tiles: tiles,
//   ).toList();
// }
//
// void _pushSaved() {
//   Navigator.of(context)
//       .push(MaterialPageRoute<void>(builder: (BuildContext context) {
//     final tiles = _saved.map((WordPair pair) {
//       return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
//     });
//     final divided = tiles.isNotEmpty
//         ? ListTile.divideTiles(context: context, tiles: tiles).toList()
//         : <Widget>[];
//     return Scaffold(
//       appBar: AppBar(title: Text('Saved Suggestions')),
//       body: ListView(
//         children: divided,
//       ),
//     );
//   }));
// }
}
