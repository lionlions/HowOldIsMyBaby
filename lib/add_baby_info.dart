import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/DB/database_helper.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AddBabyInfo extends StatefulWidget {
  const AddBabyInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddBabyInfoState();
}

class _AddBabyInfoState extends State<AddBabyInfo> {
  bool isAlreadyChooseBirthday = false;
  String mBirthday = "";
  var mIconInfo = <Object>[];
  String mBabyName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: _saveBabyInfo,
              child: const Text("完成"),
              style: TextButton.styleFrom(
                  primary: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary),
            )
          ],
          title: const Text(
            "新增寶寶資訊",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String newText) async {
                  mBabyName = newText;
                },
                decoration: const InputDecoration(
                    label: Text(
                      "小名：",
                      style: TextStyle(fontSize: 20),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    hintText: "請輸入寶寶小名",
                    hintStyle: TextStyle(fontSize: 16)),

              ),
              const SizedBox(
                height: 20,
              ),
              _getChooseIconLayout(),
              const SizedBox(
                height: 20,
              ),
              _getBirthdayInfoLayout(),
            ],
          ),
        ));
  }

  Widget _getChooseIconLayout() {
    if (mIconInfo.isNotEmpty) {
      dynamic iconInfo = mIconInfo;
      return Row(
        children: <Widget>[
          const Text("選擇頭像：", style: TextStyle(fontSize: 20)),
          CircleAvatar(
            radius: 40,
            backgroundColor: iconInfo[1],
            child: Image(
              image: AssetImage('assets/images/${iconInfo[0]}'),
              width: 65,
              height: 65,
            ),
          ),
          const SizedBox(width: 15,),
          ElevatedButton(onPressed: _chooseIcon, child: const Text("重新選擇"))
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          const Text("選擇頭像：", style: TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: _chooseIcon, child: const Text("選擇"))
        ],
      );
    }
  }

  Widget _getBirthdayInfoLayout() {
    if (!isAlreadyChooseBirthday) {
      return Row(
        children: <Widget>[
          const Text("出生日期：", style: TextStyle(fontSize: 20)),
          _generateChooseBirthdayButton("選擇"),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("出生日期：", style: TextStyle(fontSize: 20)),
          Text(
            mBirthday,
            style: const TextStyle(fontSize: 16),
          ),
          _generateChooseBirthdayButton("重新選擇"),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  mBirthday = "";
                  isAlreadyChooseBirthday = false;
                });
              },
              child: const Text("清除"))
        ],
      );
    }
  }

  Widget _generateChooseBirthdayButton(String buttonText) {
    return ElevatedButton(
        onPressed: () async {
          final result = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1911, 01, 01),
              lastDate: DateTime.now());

          if (result != null) {
            setState(() {
              mBirthday = DateFormat("yyyy-MM-dd").format(result);
              debugPrint("mBirthday: $mBirthday");
              isAlreadyChooseBirthday = true;
            });
          }
        },
        child: Text(buttonText));
  }

  Future<void> _chooseIcon() async {
    return showDialog(
        context: context,
        barrierDismissible: true, //like android cancelable, default is true
        builder: (_) {
          return const ChooseIconDialog();
        }).then((iconInfo) {
      if (iconInfo != null) {
        setState(() {
          mIconInfo = iconInfo;
        });
      }
    });
  }

  void _saveBabyInfo() async {
    // create baby's info
    String iconFileName = "";
    Color iconBackgroundColor;
    int iconBackgroundColorValue = 0;
    if (mIconInfo.isNotEmpty) {
      dynamic iconInfo = mIconInfo;
      iconFileName = iconInfo[0];
      iconBackgroundColor = iconInfo[1];
      iconBackgroundColorValue = iconBackgroundColor.value;
    }
    final baby = Baby(
        0,
        name: mBabyName,
        iconFileName: iconFileName,
        iconBackgroundColor: iconBackgroundColorValue,
        birthday: mBirthday);

    Map<String, dynamic> row = baby.toMap();

    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    // do the insert and get the id of the inserted row
    int id = await db.insert(DatabaseHelper.table, row);

    // show the results: print all rows in the db
    print(await db.query(DatabaseHelper.table));

    Navigator.pop(context, true);

  }
}

class ChooseIconDialog extends StatefulWidget {
  const ChooseIconDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChooseIconDialogState();
}

class _ChooseIconDialogState extends State<ChooseIconDialog> {
  var mCurrentSelectIconName;
  var mCurrentSelectIconBackground;

  final mImageList = <String>[
    'boy.png',
    'boy1.png',
    'boy2.png',
    'boy3.png',
    'girl.png',
    'girl1.png',
    'girl2.png',
    'girl3.png',
  ];

  final mIconBackgroundList = <Color>[
    const Color.fromARGB(255, 194, 194, 244),
    const Color.fromARGB(255, 244, 194, 194),
    const Color.fromARGB(255, 194, 244, 194),
    const Color.fromARGB(255, 208, 236, 253),
    const Color.fromARGB(255, 253, 248, 208),
    const Color.fromARGB(255, 251, 196, 159),
    const Color.fromARGB(255, 0, 0, 128),
    const Color.fromARGB(255, 128, 0, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('請選擇寶寶頭像'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('大頭'),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _createIconWidgetList()),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('背景'),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _createIconBackgroundWidgetList()),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('確定'),
          onPressed: () {
            Navigator.pop(context,
                <Object>[mCurrentSelectIconName, mCurrentSelectIconBackground]);
          },
        ),
      ],
    );
  }

  List<Widget> _createIconWidgetList() {
    final tiles = mImageList.map((String iconName) {
      return GestureDetector(
        onTap: () {
          debugPrint('$iconName onTap!!!');
          setState(() {
            mCurrentSelectIconName = iconName;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: CircleAvatar(
            radius: 43,
            backgroundColor: (mCurrentSelectIconName != null &&
                mCurrentSelectIconName == iconName)
                ? Colors.black
                : Colors.transparent,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage('assets/images/$iconName'),
                width: 65,
                height: 65,
              ),
            ),
          ),
        ),
      );
    });
    return tiles.toList();
  }

  List<Widget> _createIconBackgroundWidgetList() {
    final tiles = mIconBackgroundList.map((Color iconBackground) {
      return GestureDetector(
        onTap: () {
          debugPrint('iconBackground onTap!!!');
          setState(() {
            mCurrentSelectIconBackground = iconBackground;
          });
        },
        child: CircleAvatar(
          radius: 33,
          backgroundColor: (mCurrentSelectIconBackground != null &&
              mCurrentSelectIconBackground == iconBackground)
              ? Colors.black
              : Colors.transparent,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: iconBackground,
          ),
        ),
      );
    });
    return tiles.toList();
  }
}
