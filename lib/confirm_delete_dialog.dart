import 'package:flutter/material.dart';

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
      title: const Text('刪除'),
      content: Text('您確定要刪除 ${widget.name}'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消')),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('確定')),
      ],
    );
  }
}