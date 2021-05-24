import 'package:admin/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var isAdmin;
  var isLogged;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // look firebase
    isAdmin = false;
    isLogged = false;
    if (auth.currentUser != null) {
      isLogged = true;
      var email = auth.currentUser.email;
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: "Admin")
          .get()
          .then((snapshot) {
        print('test');
        setState(() {
          isAdmin = true;
        });
      });
    }
  }

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
            Visibility(
              child: DrawerListTile(
                title: "Admin Dashboard",
                svgSrc: "assets/icons/menu_dashbord.svg",
                press: () {
                  Navigator.pushReplacementNamed(context, routes["home"]);
                },
              ),
              visible: isAdmin,
            ),
            DrawerListTile(
              title: "My Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {},
            ),
            ExpansionTile(
              title: Text("Assets"),
              leading: Icon(
                Icons.computer,
              ),
              children: <Widget>[
                Visibility(
                  child: DrawerListTile(
                    title: "Assigned Assets",
                    svgSrc: "assets/icons/menu_tran.svg",
                    press: () {
                      Navigator.pushReplacementNamed(
                        context,
                        routes["assets"],
                      );
                    },
                  ),
                  visible: isAdmin,
                ),
                DrawerListTile(
                  title: "My Assets",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {
                    Navigator.pushReplacementNamed(
                      context,
                      routes["my_assets"],
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Requests"),
              leading: Icon(
                Icons.request_page,
              ),
              children: <Widget>[
                Visibility(
                  child: DrawerListTile(
                    title: "Request List",
                    svgSrc: "assets/icons/menu_tran.svg",
                    press: () {
                      Navigator.pushReplacementNamed(
                        context,
                        routes["requests"],
                      );
                    },
                  ),
                  visible: isAdmin,
                ),
                DrawerListTile(
                  title: "My Request",
                  svgSrc: "assets/icons/menu_tran.svg",
                  press: () {
                    Navigator.pushReplacementNamed(
                      context,
                      routes["my_requests"],
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Users"),
              leading: Icon(
                Icons.supervised_user_circle,
              ),
              children: <Widget>[
                Visibility(
                  child: DrawerListTile(
                    title: "User List",
                    svgSrc: "assets/icons/menu_tran.svg",
                    press: () {
                      Navigator.pushReplacementNamed(context, routes["users"]);
                    },
                  ),
                  visible: isAdmin,
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
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, routes["login"]);
              },
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
