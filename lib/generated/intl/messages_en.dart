// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_baby_info":
            MessageLookupByLibrary.simpleMessage("Add baby information"),
        "already_years_old": MessageLookupByLibrary.simpleMessage(
            "I am already %d years %d months %d days old"),
        "app_name": MessageLookupByLibrary.simpleMessage("How old is my baby?"),
        "baby_list_empty_hint": MessageLookupByLibrary.simpleMessage(
            "The babies list is still empty.\nPlease click \"+\" button to add baby\'s info."),
        "background": MessageLookupByLibrary.simpleMessage("Background"),
        "birthday": MessageLookupByLibrary.simpleMessage("Date of birth:"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete %s"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "head_shot": MessageLookupByLibrary.simpleMessage("Head shot"),
        "input_nick_name": MessageLookupByLibrary.simpleMessage(
            "Please enter the baby\'s nickname."),
        "nick_name": MessageLookupByLibrary.simpleMessage("Nick name:"),
        "no_search_result": MessageLookupByLibrary.simpleMessage(
            "There is no search result for keywords \"%s\""),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "please_fill_all_info": MessageLookupByLibrary.simpleMessage(
            "Please fill in the complete information."),
        "reSelect": MessageLookupByLibrary.simpleMessage("Reselect"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "select_birthday": MessageLookupByLibrary.simpleMessage(
            "Please select your baby\'s birthday."),
        "select_photo": MessageLookupByLibrary.simpleMessage("Select photo："),
        "select_photo_dialog_title":
            MessageLookupByLibrary.simpleMessage("Please select baby\'s photo")
      };
}
