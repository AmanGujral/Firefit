import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:myfitnessfire/pages/change_language.dart';
import 'package:myfitnessfire/pages/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'structures/localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widget_tree.dart';

import 'pages/home_page.dart';
import 'pages/settings.dart';
import 'pages/forgot_password_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/workout.dart';
import 'pages/day_description.dart';
import 'pages/chat_page.dart';

import 'providers/user_preferences.dart';

ThemeMode themeMode;
Locale locale;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  themeMode = await UserPreference().getUIPreferences();
  locale = await UserPreference().getLanguagePreferences();
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserPreference(),
        ),
        StreamProvider<User>.value(
            value: FirebaseAuth.instance.authStateChanges()),
      ],
      child: MyMaterialTheme(),
    );
  }
}

class MyMaterialTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userPreferences = Provider.of<UserPreference>(context);

    ThemeMode _themeMode = userPreferences.themeMode;
    print("THEME MODE : " + _themeMode.toString());
    Locale _locale = userPreferences.locale;
    print("LOCALE : " + _locale.toString());
    bool light = _themeMode == ThemeMode.light ? true : false;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: light ? Brightness.light : Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        primaryColor: Colors.redAccent,
        accentColor: Color(0xffe46b10),
        scaffoldBackgroundColor: Color.fromRGBO(240, 240, 240, 1),
        appBarTheme: AppBarTheme(
          color: Colors.red,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: Colors.redAccent,
        accentColor: Color(0xffe46b10),
        scaffoldBackgroundColor: Color.fromRGBO(40, 40, 40, 1),
        appBarTheme: AppBarTheme(
          color: Colors.red,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(20, 20, 20, 1),
        ),
      ),
      themeMode: _themeMode ?? themeMode,
      supportedLocales: [Locale('en', 'US'), Locale('fr', '')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale ?? locale,
      home: Scaffold(
        body: WidgetTree(),
      ),
      routes: {
        SettingsPage.tag: (_) => SettingsPage(),
        HomePage.tag: (_) => HomePage(),
        ForgotPasswordPage.tag: (_) => ForgotPasswordPage(),
        SignUpPage.tag: (_) => SignUpPage(),
        WorkoutPage.tag: (_) => WorkoutPage(),
        DayDescriptionPage.tag: (_) => DayDescriptionPage(),
        ChatPage.tag: (_) => ChatPage(),
        ChangeLanguagePage.tag: (_) => ChangeLanguagePage(),
        AppPurch.tag: (_) =>AppPurch(),
      },
    );
  }
}
