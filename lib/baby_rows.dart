import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:how_old_is_my_baby/WidgetUtils.dart';
import 'package:how_old_is_my_baby/action_bottom_sheet.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqflite.dart';

import 'DB/database_helper.dart';
import 'add_baby_info.dart';
import 'confirm_delete_dialog.dart';
import 'generated/l10n.dart';

class BabyRows extends StatefulWidget {
  const BabyRows(this._babyList, this.fromSearch, this._refresh, {Key? key})
      : super(key: key);

  final List<Baby> _babyList;
  final Function()? _refresh;
  final bool fromSearch;

  @override
  State<StatefulWidget> createState() => _BabyRowsState();
}

class _BabyRowsState extends State<BabyRows> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildRow(widget._babyList),
    );
  }

  List<Widget> _buildRow(List<Baby> babyList) {
    debugPrint("babyList size: ${babyList.length}");
    final tiles = babyList.map((Baby baby) {
      var nextBirthdayLeft = baby.countDownBirthday == 1
          ? WidgetUtils.nextBirthdayLeft(context, baby.birthday)
          : -1;
      debugPrint("nextBirthdayLeft: $nextBirthdayLeft");
      return InkWell(
        onLongPress:
            widget.fromSearch ? () {} : () => _openActionBottomSheet(baby),
        onTap: widget.fromSearch
            ? () {}
            : () => _editBabyInfoPage(baby: baby, isUpdate: true),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(baby.iconBackgroundColor),
                          child: Image(
                            image: AssetImage(
                                'assets/images/${baby.iconFileName}'),
                            width: 65,
                            height: 65,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                baby.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(WidgetUtils.howOld(context, baby.birthday)),
                            ]),
                      ],
                    ),
                    if (nextBirthdayLeft != -1 &&
                        nextBirthdayLeft > 0 &&
                        nextBirthdayLeft < 365)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildCountDownBirthday(nextBirthdayLeft),
                      )
                  ],
                ))),
      );
    });
    return tiles.toList();
  }

  Widget _buildCountDownBirthday(int nextBirthdayLeft) {
    if (nextBirthdayLeft < 10) {
      var digit = nextBirthdayLeft % 10;
      return Column(
        children: [
          Wrap(
            children: [
              _countDownNumber(0),
              const SizedBox(
                width: 3,
              ),
              _countDownNumber(digit)
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          const Text(
            "DAYS LEFT",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      );
    } else if (nextBirthdayLeft < 100) {
      var digit = nextBirthdayLeft % 10;
      var tensDigit = nextBirthdayLeft ~/ 10;
      return Column(
        children: [
          Wrap(
            children: [
              _countDownNumber(tensDigit),
              const SizedBox(
                width: 3,
              ),
              _countDownNumber(digit)
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          const Text(
            "DAYS LEFT",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      );
    } else {
      var digit = nextBirthdayLeft % 10;
      var tensDigit = nextBirthdayLeft % 100 ~/ 10;
      var hundredsDigit = nextBirthdayLeft ~/ 100;
      return Column(
        children: [
          Wrap(
            children: [
              _countDownNumber(hundredsDigit),
              const SizedBox(
                width: 3,
              ),
              _countDownNumber(tensDigit),
              const SizedBox(
                width: 3,
              ),
              _countDownNumber(digit)
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          const Text(
            "DAYS LEFT",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      );
    }
  }

  Stack _countDownNumber(int number) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              child: Container(
                width: 30.0,
                height: 20.0,
                color: Colors.amber,
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0)),
              child: Container(
                width: 30.0,
                height: 20.0,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        Text(
          "$number",
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  void _editBabyInfoPage({Baby? baby, bool? isUpdate}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddBabyInfo(
        baby: baby,
        isUpdate: isUpdate,
      );
    })).then((needToUpdate) {
      if (needToUpdate && widget._refresh != null) {
        widget._refresh!();
      }
    });
  }

  Future<void> _openActionBottomSheet(Baby baby) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return ActionBottomSheet(baby);
        }).then((deleteAndUpdateList) {
      if (deleteAndUpdateList) {
        _deleteItem(baby.id);
        if (widget._refresh != null) {
          widget._refresh!();
        }
      }
    });
  }

  void _deleteItem(int id) async {
    // Get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    await db.delete(DatabaseHelper.table, where: "_id = ?", whereArgs: [id]);

    if (widget._refresh != null) {
      widget._refresh!();
    }
  }
}
