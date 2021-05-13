import 'package:admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // sifrenin visibilty'sini kontrol edebilmek icin boolean degisken
  bool hidePassword = true;
  var _userIdController = TextEditingController();
  var _passwordController = TextEditingController();

  String testValue = "Giris Bekliyor";
  bool add = true;

  @override
  void initState() {
    super.initState();
    add = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Fırtınalar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                        //style: Theme.of(context).,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      // User id'nin girileceği TextField
                      TextField(
                        controller: _userIdController,
                        decoration: InputDecoration(
                          hintText: "User Id",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.face,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      // Password'un girilecegi TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          // Visibilty kontrolu icin suffixIcon
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FlatButton(
                        onPressed: () async {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: _userIdController.text.toString(),
                                    password:
                                        _passwordController.text.toString());

                            print('Authenticated');
                            Navigator.pushReplacementNamed(
                                context, routes["home"]);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                      ),
                      add == true
                          ? Text(
                              "",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800]),
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
