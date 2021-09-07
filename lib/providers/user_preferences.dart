import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum preferences { SystemPreference, Light, Dark }

class UserPreference with ChangeNotifier {
  //Ui
  bool systemPreferenceUiSwitch;
  bool lightSwitch;
  bool darkSwitch;
  ThemeMode themeMode; // = ThemeMode.system;
  //Language
  bool systemPreferenceLanguageSwitch = true;
  bool enSwitch = false;
  bool frSwitch = false;
  Locale locale;

  UserPreference() {
    getUIPreferences();
    getLanguagePreferences();
  }

  Future<ThemeMode> getUIPreferences() async {
    final preferences =
        await SharedPreferences.getInstance(); //get UI preferences
    systemPreferenceUiSwitch =
        preferences.getBool('systemUIPreference') ?? true;
    lightSwitch = preferences.getBool("lightSwitch") ?? false;
    darkSwitch = preferences.getBool("darkSwitch") ?? false;

    //set theme based on the preference
    !systemPreferenceUiSwitch
        ? lightSwitch
            ? themeMode = ThemeMode.light
            : themeMode = ThemeMode.dark
        : themeMode = ThemeMode.system;
    return themeMode;
  }

  void setUIPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    //set UI preferences
    preferences.setBool('systemUIPreference', systemPreferenceUiSwitch);
    preferences.setBool('lightSwitch', lightSwitch);
    preferences.setBool('darkSwitch', darkSwitch);
  }

  Future<Locale> getLanguagePreferences() async {
    final preferences = await SharedPreferences.getInstance();

    //get Language preferences
    systemPreferenceLanguageSwitch =
        preferences.getBool('systemLanguagePreference') ?? true;
    enSwitch = preferences.getBool("enSwitch") ?? false;
    frSwitch = preferences.getBool("frSwitch") ?? false;

    //set locale based on the preference
    !systemPreferenceLanguageSwitch
        ? enSwitch
            ? locale = Locale("en")
            : locale = Locale("fr")
        : locale = Locale(Platform.localeName);
    return locale;
  }

  void setLanguagePreferences() async {
    final preferences = await SharedPreferences.getInstance();

    //set UI preferences
    preferences.setBool(
        'systemLanguagePreference', systemPreferenceLanguageSwitch);
    preferences.setBool('enSwitch', enSwitch);
    preferences.setBool('frSwitch', frSwitch);
  }

  void changeUiPreferences(selectedPreference) {
    switch (selectedPreference) {
      case 0:
        systemPreferenceUiSwitch = true;
        lightSwitch = false;
        darkSwitch = false;
        themeMode = ThemeMode.system;
        break;
      case 1:
        systemPreferenceUiSwitch = false;
        lightSwitch = true;
        darkSwitch = false;
        themeMode = ThemeMode.light;
        break;
      case 2:
        systemPreferenceUiSwitch = false;
        lightSwitch = false;
        darkSwitch = true;
        themeMode = ThemeMode.dark;
        break;
      default:
    }
    setUIPreferences();
    notifyListeners();
  }

  void changeLanguagePreferences(selectedPreference) {
    switch (selectedPreference) {
      case 0:
        systemPreferenceLanguageSwitch = true;
        enSwitch = false;
        frSwitch = false;
        locale = Locale(Platform.localeName);
        break;
      case 1:
        systemPreferenceLanguageSwitch = false;
        enSwitch = true;
        frSwitch = false;
        locale = Locale("en");
        break;
      case 2:
        systemPreferenceLanguageSwitch = false;
        enSwitch = false;
        frSwitch = true;
        locale = Locale("fr");
        break;
      default:
    }
    setLanguagePreferences();
    notifyListeners();
  }
}
