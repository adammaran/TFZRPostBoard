import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/pages/AddNote.dart';
import 'package:informatortfzr/pages/EditNote.dart';
import 'package:informatortfzr/pages/Register.dart';
import 'TeacherRequests.dart';
import 'package:informatortfzr/pages/main.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Login.dart';

var nextScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      nextScreen = LoginPage();
    } else {
      nextScreen = MyHomePage();
    }
  });

  runApp(new MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => StartApp(),
      '/Login': (context) => LoginPage(),
      '/Register': (context) => RegisterPageState(),
      '/Home': (context) => MyHomePage(),
      '/AddPost': (context) => AddNote(),
      '/EditPost': (context) => EditNote(),
      '/TeacherRequests': (context) => TeacherRequests(),
    },
  ));
}

class StartApp extends StatefulWidget {
  var nextScreen;

  @override
  SplashScreenPage createState() {
    return new SplashScreenPage();
  }
}

class SplashScreenPage extends State<StartApp> {

  @override
  Widget build(BuildContext context) {
    print(nextScreen);
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: nextScreen,
      title: new Text('TFZR OGLASNA'),
    );
  }
}
