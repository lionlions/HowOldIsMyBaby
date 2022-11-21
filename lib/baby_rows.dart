import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/Model/baby.dart';
import 'package:sqflite/sqflite.dart';

import 'DB/database_helper.dart';
import 'add_baby_info.dart';
import 'confirm_delete_dialog.dart';

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
      return InkWell(
        onLongPress:
            widget.fromSearch ? () {} : () => _openConfirmDeleteDialog(baby),
        onTap: widget.fromSearch
            ? () {}
            : () => _editBabyInfoPage(baby: baby, isUpdate: true),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(baby.iconBackgroundColor),
                child: Image(
                  image: AssetImage('assets/images/${baby.iconFileName}'),
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
                    _howOld(baby.birthday),
                  ]),
            ],
          ),
        )),
      );
    });
    return tiles.toList();
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

  Future<void> _openConfirmDeleteDialog(Baby baby) async {
    return showDialog(
        context: context,
        builder: (_) {
          return ConfirmDeleteDialog(baby.name);
        }).then((deleteAndUpdateList) {
      if (deleteAndUpdateList) {
        _deleteItem(baby.id);
        if (widget._refresh != null) {
          widget._refresh!();
        }
      }
    });
  }

  Text _howOld(String birthday) {
    var startDate = DateTime.parse(birthday);
    var currentDate = DateTime.now();
    var difference = currentDate.difference(startDate);
    var differenceInDays = difference.inDays;
    var years = differenceInDays ~/ 365;
    var months = (differenceInDays % 365).toInt() ~/ 31;
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
    debugPrint("differenceInDays: $differenceInDays");
    debugPrint("years: $years");
    debugPrint("months: $months");
    debugPrint("currentDateYear: $currentDateYear");
    debugPrint("lastMonth: $lastMonth");
    debugPrint("birthdayDay: $birthdayDay");
    debugPrint("leftday: $leftday");
    return Text("我已經$years歲$months月$leftday天囉");
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
