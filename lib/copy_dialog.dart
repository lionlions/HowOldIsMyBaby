import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:how_old_is_my_baby/WidgetUtils.dart';
import 'package:how_old_is_my_baby/baby_rows.dart';
import 'package:sprintf/sprintf.dart';

import 'Model/baby.dart';
import 'generated/l10n.dart';

class CopyDialog extends StatefulWidget {
  const CopyDialog(this.baby, {Key? key}) : super(key: key);

  final Baby baby;

  @override
  State<StatefulWidget> createState() => _CopyDialogState();
}

class _CopyDialogState extends State<CopyDialog> {
  @override
  Widget build(BuildContext context) {
    String howOld = WidgetUtils.howOld(context, widget.baby.birthday);
    String howOldWithHashTag =
        WidgetUtils.howOldWithHashTag(context, widget.baby.birthday);

    return SimpleDialog(
      title: Text(S.of(context).select_copy_format),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: howOld));
            Fluttertoast.showToast(
                msg: S.of(context).copy_success,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
            Navigator.pop(context);
          },
          child: Text(howOld),
        ),
        SimpleDialogOption(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: howOldWithHashTag));
            Fluttertoast.showToast(
                msg: S.of(context).copy_success,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
            Navigator.pop(context);
          },
          child: Text(howOldWithHashTag),
        )
      ],
    );
  }
}
