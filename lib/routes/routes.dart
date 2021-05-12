import 'package:admin/screens/users/users_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/users/users_screen.dart';

final routes = <String, String>{
  "home": "/home",
  "users": "/users",
};

getRoutes() {
  return <String, WidgetBuilder>{
    routes["home"]: (context) => new DashboardScreen(),
    routes["users"]: (context) => new UsersScreen(),
  };
}
