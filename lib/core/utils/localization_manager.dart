import 'package:almasheed/core/local/shared_prefrences.dart';
import 'package:almasheed/generated/l10n.dart';
import 'package:flutter/material.dart';

class LocalizationManager {
  static List<Locale> supportedLocales = const [Locale("ar"), Locale("en")];
  static late int currentLocale;
  static Future<void> init() async {
    await CacheHelper.getData(key: "currentLocale").then((value) {
      if (value != null) {
        currentLocale = value;
      } else {
        currentLocale = 0;
      }
    });
  }

  static Future<void> setLocale(int localeIndex) async {
    if (currentLocale != localeIndex) {
      currentLocale = localeIndex;
      await S.load(getCurrentLocale());
      await saveChanges();
    }
  }

  static Future<void> saveChanges() async {
    await CacheHelper.saveData(key: "currentLocale", value: currentLocale);
  }

  static Locale getCurrentLocale() {
    return supportedLocales[currentLocale];
  }
}
