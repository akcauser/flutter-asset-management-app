import 'package:admin/models/Role.dart';
import 'package:admin/models/User.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:admin/screens/users/components/users_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _shoppingItemAddFormkey = GlobalKey<FormState>();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addItem(User user) {
    return usersCollection
        .add({
          'image': user.image,
          'email': user.email,
          'name': user.name,
          'role': user.role
        })
        .then((value) => print('item added'))
        .catchError((error) => print('error occured'));
  }

  String _selectedRole;
  var _roles = List<DropdownMenuItem>();
  _loadRoles() {
    Role.getRoles().forEach((role) {
      _roles.add(DropdownMenuItem(
        child: Text(role),
        value: role,
      ));
    });
  }

  void initState() {
    super.initState();
    _loadRoles();
    print(_roles);
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController _userNameFieldController =
        new TextEditingController();
    TextEditingController _userEmailFieldController =
        new TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'New User',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
          content: Form(
            key: _shoppingItemAddFormkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _userNameFieldController,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _userEmailFieldController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    items: _roles,
                    value: _selectedRole,
                    hint: Text("Role"),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                if (_shoppingItemAddFormkey.currentState.validate()) {
                  User user = new User(
                    _userEmailFieldController.text.toString(),
                    _userNameFieldController.text.toString(),
                    _selectedRole,
                  );
                  addItem(user);
                  // Alert dialog close
                  Navigator.of(context).pop();
                }
              },
              elevation: 5.0,
              child: Text('Add'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    createAlertDialog(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add New"),
                ),
                SizedBox(height: defaultPadding),
                UsersList(),
                if (Responsive.isMobile(context))
                  SizedBox(height: defaultPadding),
                SizedBox(height: defaultPadding),
                //StarageDetails()
              ],
            ),
          ),
          if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
        ],
      ),
    );
  }
}
