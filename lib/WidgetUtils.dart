import 'package:flutter/cupertino.dart';
import 'package:sprintf/sprintf.dart';

import 'generated/l10n.dart';

class WidgetUtils {
  static String howOld(BuildContext context, String birthday) {
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
    return sprintf(S.of(context).already_years_old, [years, months, leftday]);
  }

  static String howOldWithHashTag(BuildContext context, String birthday) {
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
    return sprintf(S.of(context).already_years_old_hash_tag, [years, months, leftday]);
  }
}
