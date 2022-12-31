// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `How old is my baby?`
  String get app_name {
    return Intl.message(
      'How old is my baby?',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `The babies list is still empty.\nPlease click "+" button to add baby's info.`
  String get baby_list_empty_hint {
    return Intl.message(
      'The babies list is still empty.\nPlease click "+" button to add baby\'s info.',
      name: 'baby_list_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `There is no search result for keywords "%s"`
  String get no_search_result {
    return Intl.message(
      'There is no search result for keywords "%s"',
      name: 'no_search_result',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Remove "%s"`
  String get remove_item {
    return Intl.message(
      'Remove "%s"',
      name: 'remove_item',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove %s`
  String get remove_confirm {
    return Intl.message(
      'Are you sure you want to remove %s',
      name: 'remove_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `I am already %d years %d months %d days old`
  String get already_years_old {
    return Intl.message(
      'I am already %d years %d months %d days old',
      name: 'already_years_old',
      desc: '',
      args: [],
    );
  }

  /// `#%dY%dM%dD`
  String get already_years_old_hash_tag {
    return Intl.message(
      '#%dY%dM%dD',
      name: 'already_years_old_hash_tag',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Add baby information`
  String get add_baby_info {
    return Intl.message(
      'Add baby information',
      name: 'add_baby_info',
      desc: '',
      args: [],
    );
  }

  /// `Nick name:`
  String get nick_name {
    return Intl.message(
      'Nick name:',
      name: 'nick_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the baby's nickname.`
  String get input_nick_name {
    return Intl.message(
      'Please enter the baby\'s nickname.',
      name: 'input_nick_name',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth:`
  String get birthday {
    return Intl.message(
      'Date of birth:',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Please select your baby's birthday.`
  String get select_birthday {
    return Intl.message(
      'Please select your baby\'s birthday.',
      name: 'select_birthday',
      desc: '',
      args: [],
    );
  }

  /// `Select photo：`
  String get select_photo {
    return Intl.message(
      'Select photo：',
      name: 'select_photo',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Reselect`
  String get reSelect {
    return Intl.message(
      'Reselect',
      name: 'reSelect',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the complete information.`
  String get please_fill_all_info {
    return Intl.message(
      'Please fill in the complete information.',
      name: 'please_fill_all_info',
      desc: '',
      args: [],
    );
  }

  /// `Please select baby's photo`
  String get select_photo_dialog_title {
    return Intl.message(
      'Please select baby\'s photo',
      name: 'select_photo_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Head shot`
  String get head_shot {
    return Intl.message(
      'Head shot',
      name: 'head_shot',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get background {
    return Intl.message(
      'Background',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Choose format`
  String get select_copy_format {
    return Intl.message(
      'Choose format',
      name: 'select_copy_format',
      desc: '',
      args: [],
    );
  }

  /// `Copy success!!`
  String get copy_success {
    return Intl.message(
      'Copy success!!',
      name: 'copy_success',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
