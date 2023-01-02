import 'package:how_old_is_my_baby/DB/database_helper.dart';

class Baby {
  final int id;
  final String name;
  final String iconFileName;
  final int iconBackgroundColor;
  final String birthday;
  final int countDownBirthday;

  Baby(this.id,
      {required this.name,
      required this.iconFileName,
      required this.iconBackgroundColor,
      required this.birthday,
      required this.countDownBirthday});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnIconFileName: iconFileName,
      DatabaseHelper.columnIconBackgroundColor: iconBackgroundColor,
      DatabaseHelper.columnBirthday: birthday,
      DatabaseHelper.columnCountDownBirthday: countDownBirthday
    };
  }
}
