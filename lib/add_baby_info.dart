import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:how_old_is_my_baby/DB/database_helper.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBabyInfo extends StatefulWidget {
  AddBabyInfo({Key? key, this.baby, this.isUpdate}) : super(key: key);

  final Baby? baby;
  final bool? isUpdate;

  @override
  State<StatefulWidget> createState() => _AddBabyInfoState();
}

class _AddBabyInfoState extends State<AddBabyInfo> {
  bool isAlreadyChooseBirthday = false;
  String mBirthday = "";
  var mIconInfo = <Object>[];
  String mBabyName = "";
  bool isAlreadyInit = false;
  TextEditingController mBirthdayController = TextEditingController();

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _bannerAd = BannerAd(
        adUnitId: getAdUnitId(),
        size: size,
        request: AdRequest(),
        listener: BannerAdListener(onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set the height of the ad container.
            _bannerAd = ad as BannerAd;
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        }));

    return _bannerAd!.load();
  }

  String getAdUnitId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-6530823503033008/2192140452';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAlreadyInit && widget.baby != null) {
      if (widget.baby?.iconFileName != null &&
          widget.baby!.iconFileName != "" &&
          widget.baby?.iconBackgroundColor != null &&
          widget.baby!.iconBackgroundColor != 0) {
        mIconInfo = <Object>[
          widget.baby!.iconFileName,
          Color(widget.baby!.iconBackgroundColor)
        ];
      }
      if (widget.baby?.birthday != null && widget.baby!.birthday != "") {
        isAlreadyChooseBirthday = true;
        mBirthday = widget.baby!.birthday;
      }
      if (widget.baby?.name != null && widget.baby!.name != "") {
        mBabyName = widget.baby!.name;
      }
      isAlreadyInit = true;
    }
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: _saveBabyInfo,
              child: const Text("完成"),
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary),
            )
          ],
          title: const Text(
            "新增寶寶資訊",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: mBabyName,
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
                    TextFormField(
                      readOnly: true,
                      controller: mBirthdayController..text = mBirthday,
                      onTap: () async {
                        final result = await showDatePicker(
                            context: context,
                            initialDate: _getDefaultBirthdayDatePickerDate(),
                            firstDate: DateTime(1911, 01, 01),
                            lastDate: DateTime.now());

                        if (result != null) {
                          setState(() {
                            mBirthday = DateFormat("yyyy-MM-dd").format(result);
                            debugPrint("mBirthday: $mBirthday");
                            mBirthdayController.text = mBirthday;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today_rounded),
                          label: Text(
                            "出生日期：",
                            style: TextStyle(fontSize: 20),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          hintText: "請選擇寶寶生日",
                          hintStyle: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _getChooseIconLayout(),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // _getBirthdayInfoLayout(),
                  ],
                ),
              ),
              if (_bannerAd != null && _isAdLoaded)
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(
                    ad: _bannerAd!,
                  ),
                )
            ],
          ),
        ));
  }

  DateTime _getDefaultBirthdayDatePickerDate() {
    if (mBirthday.isEmpty) {
      return DateTime.now();
    } else {
      return DateTime.parse(mBirthday);
    }
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
          const SizedBox(
            width: 15,
          ),
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

    if (mBabyName.isEmpty ||
        iconFileName.isEmpty ||
        iconBackgroundColorValue == 0) {
      Fluttertoast.showToast(
          msg: "請填寫完整資訊",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
      return;
    }

    final baby = Baby(0,
        name: mBabyName,
        iconFileName: iconFileName,
        iconBackgroundColor: iconBackgroundColorValue,
        birthday: mBirthday);

    Map<String, dynamic> row = baby.toMap();

    if (widget.isUpdate == true && widget.baby?.id != 0) {
      _updateItem(widget.baby!.id, row);
      return;
    }

    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    // do the insert and get the id of the inserted row
    int id = await db.insert(DatabaseHelper.table, row);

    // show the results: print all rows in the db
    print(await db.query(DatabaseHelper.table));

    Navigator.pop(context, true);
  }

  void _updateItem(int id, Map<String, dynamic> map) async {
    // Get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    await db
        .update(DatabaseHelper.table, map, where: "_id = ?", whereArgs: [id]);

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
