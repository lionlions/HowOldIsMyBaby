import 'package:flutter/material.dart';
import 'package:how_old_is_my_baby/copy_dialog.dart';
import 'package:how_old_is_my_baby/generated/l10n.dart';
import 'package:sprintf/sprintf.dart';

import 'Model/baby.dart';
import 'confirm_delete_dialog.dart';

class ActionBottomSheet extends StatefulWidget {
  const ActionBottomSheet(this.baby, {Key? key}) : super(key: key);

  final Baby baby;

  @override
  State<StatefulWidget> createState() => _ActionBottomSheetState();
}

class _ActionBottomSheetState extends State<ActionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(sprintf(S.of(context).remove_item, [widget.baby.name])),
              onTap: () {
                print("delete click");
                _openConfirmDeleteDialog(widget.baby);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(S.of(context).copy),
              onTap: () {
                print("copy click");
                Navigator.pop(context);
                _openCopyDialog(widget.baby);
              },
            )
          ],
        );
      },
      onClosing: () {},
    );
  }

  Future<void> _openConfirmDeleteDialog(Baby baby) async {
    return showDialog(
        context: context,
        builder: (_) {
          return ConfirmDeleteDialog(baby.name);
        }).then((deleteAndUpdateList) {
      Navigator.pop(context, deleteAndUpdateList);
    });
  }

  Future<void> _openCopyDialog(Baby baby) async{
    return showDialog(context: context, builder: (_){
      return CopyDialog(baby);
    });
  }
}
