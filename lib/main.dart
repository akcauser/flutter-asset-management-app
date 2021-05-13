import 'package:admin/constants.dart';
import 'package:admin/routes/routes.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'dart:async';

import 'screens/dashboard/dashboard_screen.dart';

//StreamController<Widget> streamController = StreamController<Widget>();
void main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: _loginControl(),
      routes: getRoutes(),
    );
  }

  _loginControl() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return LoginScreen();
    }

    print(auth.currentUser.uid);
  }
}
