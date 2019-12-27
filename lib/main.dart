import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holidays/managers/app_manager.dart';
import 'package:holidays/models/user.dart';
import 'package:holidays/screens/auth/login.dart';
import 'package:holidays/screens/auth/sign_up.dart';
import 'package:holidays/screens/home.dart';
import 'package:holidays/screens/intro/intro.dart';
import 'package:holidays/screens/profile.dart';
import 'package:holidays/screens/root.dart';
import 'package:holidays/services/api_service.dart';
import 'package:holidays/services/auth_service.dart';
import 'package:holidays/util/const.dart';
import 'package:holidays/view_model/google_button.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';
import 'services/locator.dart';
import 'view_model/entry.dart';
import 'view_model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await setupApi();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EntryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleButtonViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> setupApi() async {
  await locator<ApiService>().clientSetup();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        builder: (context, widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => AppManager(
              child: widget,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Root(),
          Intro.routeName: (context) => Intro(),
          Login.routeName: (context) => Login(),
          SignUp.routeName: (context) => SignUp(),
          Home.routeName: (context) => Home(),
          Profile.routeName: (context) => Profile(),
        },
      ),
    );
  }
}
