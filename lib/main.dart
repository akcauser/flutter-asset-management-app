import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/routes/routes.dart';
import 'package:admin/screens/layouts/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'dart:async';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/main/main_screen.dart';

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
      home: DashboardScreen(),
      routes: getRoutes(),
    );
  }
}
