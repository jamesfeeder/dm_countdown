import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get theme => _theme;
  late bool _isDark;
  bool get isDark => _isDark;
  late bool _isLoaded;

  void loadDefault() async {
    if (!_isLoaded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("isDark")) {
        if (prefs.getBool("isDark")!) {
          _theme = ThemeMode.dark;
          _isDark = true;
        } else {
          _theme = ThemeMode.light;
          _isDark = false;
        }
      }
      print('Loaded Setting');
      _isLoaded = true;
      notifyListeners();
    }
  }

  void saveSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", value);
    print('Saved Setting');
  }

  set isDark(bool value) {
    _isDark = value;
    if (_isDark) {
      _theme = ThemeMode.dark;
    } else {
      _theme = ThemeMode.light;
    }
    saveSetting(value);
    // save
    notifyListeners();
  }

}