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
      return InkWell(
        onLongPress:
            widget.fromSearch ? () {} : () => _openActionBottomSheet(baby),
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
                    Text(WidgetUtils.howOld(context, baby.birthday)),
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
