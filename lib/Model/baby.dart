import 'package:how_old_is_my_baby/DB/database_helper.dart';

class Baby{
  final String name;
  final String iconFileName;
  final int iconBackgroundColor;
  final String birthday;

  Baby({required this.name, required this.iconFileName, required this.iconBackgroundColor, required this.birthday});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnIconFileName: iconFileName,
      DatabaseHelper.columnIconBackgroundColor: iconBackgroundColor,
      DatabaseHelper.columnBirthday: birthday
    };
  }
}