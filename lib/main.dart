import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:how_old_is_my_baby/baby_rows.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqflite.dart';
import 'DB/database_helper.dart';
import 'add_baby_info.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportLocales) {
        //Handle Chinese Language
        if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            return const Locale('zh', 'TW');
          } else {
            return const Locale('zh', 'CN');
          }
        }
        return null;
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Baby> _babyList = [];
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
        return 'ca-app-pub-6530823503033008/6032935974';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
  }

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
      return Baby(maps[index][DatabaseHelper.columnId],
                  name: maps[index][DatabaseHelper.columnName],
                  iconFileName: maps[index][DatabaseHelper.columnIconFileName],
                  iconBackgroundColor: maps[index][DatabaseHelper.columnIconBackgroundColor],
                  birthday: maps[index][DatabaseHelper.columnBirthday],
                  countDownBirthday: maps[index][DatabaseHelper.columnCountDownBirthday]);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _addBabyInfoPage({Baby? baby, bool? isUpdate}) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return AddBabyInfo(
          baby: baby,
          isUpdate: isUpdate,
        );
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
        title: Text(S.of(context).app_name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: _addBabyInfoPage,
          ),
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(_babyList),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
          child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          (_babyList.isEmpty)
              ? Center(
                  child: Text(
                    S.of(context).baby_list_empty_hint,
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(
                  child: BabyRows(_babyList, false, () {
                    setState(() {
                      getBabyList();
                    });
                  }),
                  margin: EdgeInsets.only(
                      bottom: (_bannerAd != null && _isAdLoaded)
                          ? _bannerAd!.size.height.toDouble() + 10
                          : 0.0),
                ),
          if (_bannerAd != null && _isAdLoaded)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(
                ad: _bannerAd!,
              ),
            )
        ],
      )),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate(this._babyList, {Key? key}) : super();

  final List<Baby> _babyList;

  Future<List<Baby>> _queryItem(String babyName) async {
    // Get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> maps = await db
        .query(DatabaseHelper.table, where: "name = ?", whereArgs: [babyName]);

    return List.generate(maps.length, (index) {
      return Baby(maps[index][DatabaseHelper.columnId],
                  name: maps[index][DatabaseHelper.columnName],
                  iconFileName: maps[index][DatabaseHelper.columnIconFileName],
                  iconBackgroundColor: maps[index][DatabaseHelper.columnIconBackgroundColor],
                  birthday: maps[index][DatabaseHelper.columnBirthday],
                  countDownBirthday: maps[index][DatabaseHelper.columnCountDownBirthday]);
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), // close searchbar
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<List<Baby>>(
        future: _queryItem(query),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return BabyRows(snapshot.data!, true, null);
          } else {
            return Center(
              child: Text(sprintf(S.of(context).no_search_result, [query])),
            );
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Baby> suggestions = _babyList.where((baby) {
      final babyName = baby.name;
      final result = babyName.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
              title: Text(suggestion.name),
              onTap: () {
                query = suggestion.name;
              });
        });
  }
}
