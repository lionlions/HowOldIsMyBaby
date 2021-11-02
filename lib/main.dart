import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:sqflite/sqflite.dart';
import 'DB/database_helper.dart';
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
      home: const MyHomePage(title: '我的寶寶幾歲了?'),
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
  List<Baby> _babyList = [];

  @override
  void initState() {
    getBabyList();
  }

  void getBabyList() async {
    final list = await getBabyListFromDB();
    debugPrint("list: $list");
    setState(() {
      _babyList = list;
    });
  }

  Future<List<Baby>> getBabyListFromDB() async {
    // Get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    // Query the table for all the Baby
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.table);

    //Convert the List<Map<String, dynamic>> into the List<Baby>
    return List.generate(maps.length, (index) {
      return Baby(
          name: maps[index][DatabaseHelper.columnName],
          iconFileName: maps[index][DatabaseHelper.columnIconFileName],
          iconBackgroundColor: maps[index]
              [DatabaseHelper.columnIconBackgroundColor],
          birthday: maps[index][DatabaseHelper.columnBirthday]);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _addBabyInfoPage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return const AddBabyInfo();
      })).then((needToUpdate) {
        if (needToUpdate) {
          setState(() {
            debugPrint("update layout");
            getBabyList();
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
      body: (_babyList.isEmpty)
          ? const Center(
              child: Text("list is empty"),
            )
          : ListView(
              children: _buildRow(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBabyInfoPage,
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> _buildRow() {
    final tiles = _babyList.map((Baby baby) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(baby.iconBackgroundColor),
            child: Image(
              image: AssetImage('assets/images/${baby.iconFileName}'),
              width: 65,
              height: 65,
            ),
          ),
          const SizedBox(width: 10,),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  baby.name,
                  style: const TextStyle(fontSize: 20),
                ),
                _howOld(baby.birthday),
              ]
          ),
        ],),)
      );
    });
    return tiles.toList();
  }

  Text _howOld(String birthday) {
    var startDate = DateTime.parse(birthday);
    var currentDate = DateTime.now();
    var difference = currentDate.difference(startDate);
    var differenceInDays = difference.inDays;
    var years = differenceInDays ~/ 365;
    var months = (differenceInDays % 365).toInt() ~/ 30;
    var currentDateYear = currentDate.year;
    var lastMonth = currentDate.month;
    var birthdayDay = startDate.day;
    if (currentDate.day < birthdayDay) {
      if (currentDate.month == 1) {
        lastMonth = 12;
        currentDateYear -= 1;
      } else {
        lastMonth -= 1;
      }
    }
    var leftday = currentDate
        .difference(DateTime(currentDateYear, lastMonth, birthdayDay))
        .inDays;
    debugPrint("============");
    debugPrint("years: $years");
    debugPrint("months: $months");
    debugPrint("currentDateYear: $currentDateYear");
    debugPrint("lastMonth: $lastMonth");
    debugPrint("birthdayDay: $birthdayDay");
    debugPrint("leftday: $leftday");
    return Text("我已經$years歲$months月$leftday天囉");
  }
}
