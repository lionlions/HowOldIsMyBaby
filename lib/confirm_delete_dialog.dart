import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'generated/l10n.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  const ConfirmDeleteDialog(this.name, {Key? key}) : super(key: key);

  final String name;

  @override
  State<StatefulWidget> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).delete),
      content: Text(sprintf(S.of(context).delete_confirm, [widget.name])),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(S.of(context).cancel)),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(S.of(context).ok)),
      ],
    );
  }
}