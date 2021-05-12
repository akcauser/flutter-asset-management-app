import 'package:admin/main.dart';
import 'package:admin/routes/routes.dart';
import 'package:admin/screens/users/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Admin Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                Navigator.pushReplacementNamed(context, routes["home"]);
              },
            ),
            DrawerListTile(
              title: "Employee Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {},
            ),
            ExpansionTile(
              title: Text("Assets"),
              leading: Icon(
                Icons.computer,
              ),
              children: <Widget>[
                DrawerListTile(
                  title: "Assign new assets",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
                DrawerListTile(
                  title: "Assigned Assets",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
                DrawerListTile(
                  title: "My Assets",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Requests"),
              leading: Icon(
                Icons.request_page,
              ),
              children: <Widget>[
                DrawerListTile(
                  title: "Request new assets",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
                DrawerListTile(
                  title: "Request List",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
                DrawerListTile(
                  title: "My Request",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Users"),
              leading: Icon(
                Icons.supervised_user_circle,
              ),
              children: <Widget>[
                DrawerListTile(
                  title: "User List",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {
                    Navigator.pushReplacementNamed(context, routes["users"]);
                  },
                ),
                DrawerListTile(
                  title: "My Profile",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {},
                ),
              ],
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {},
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    // For selecting those three line once press "Command+D"
    @required this.title,
    @required this.svgSrc,
    @required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
