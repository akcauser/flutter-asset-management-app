import 'package:admin/screens/users/users_screen.dart';
import 'package:flutter/material.dart';

final routes = <String, String>{
  "users": "/users",
};

getRoutes() {
  return <String, WidgetBuilder>{
    routes["users"]: (context) => new UsersScreen(),
  };
}
