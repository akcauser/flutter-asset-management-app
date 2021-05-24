import 'package:admin/screens/assets/assets_screen.dart';
import 'package:admin/screens/my_assets/my_assets_screen.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/screens/my_profile/my_profile_screen.dart';
import 'package:admin/screens/my_requests/my_requests_screen.dart';
import 'package:admin/screens/requests/requests_screen.dart';
import 'package:admin/screens/users/users_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/users/users_screen.dart';

final routes = <String, String>{
  "home": "/home",
  "users": "/users",
  "login": "/login",
  "assets": "/assets",
  "my_assets": "/my_assets",
  "my_requests": "/my_requests",
  "requests": "/requests",
  "my_profile": "/my_profile",
};

getRoutes() {
  return <String, WidgetBuilder>{
    routes["home"]: (context) => new DashboardScreen(),
    routes["users"]: (context) => new UsersScreen(),
    routes["login"]: (context) => new LoginScreen(),
    routes["assets"]: (context) => new AssetsScreen(),
    routes["my_assets"]: (context) => new MyAssetsScreen(),
    routes["my_requests"]: (context) => new MyRequestsScreen(),
    routes["requests"]: (context) => new RequestsScreen(),
    routes["my_profile"]: (context) => new MyProfileScreen(),
  };
}
