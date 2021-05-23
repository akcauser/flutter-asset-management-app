import 'package:admin/models/AssetType.dart';
import 'package:admin/models/Request.dart';
import 'package:admin/screens/my_requests/components/my_requests_list.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class MyRequestsScreen extends StatefulWidget {
  @override
  _MyRequestsScreenState createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final _shoppingItemAddFormkey = GlobalKey<FormState>();
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addItem(Request request) {
    var data = {
      'name': request.name,
      'type': request.type,
      'userReference': request.userReference,
      'createdAt': request.createdAt,
      'status': 'Pending',
    };

    return requestsCollection
        .add(data)
        .then((value) => print('item added'))
        .catchError((error) => print('error occured'));
  }

  String _selectedType;
  var _assetTypes = List<DropdownMenuItem>();
  _loadAssetTypes() {
    AssetType.getAssetTypes().forEach((assetType) {
      _assetTypes.add(DropdownMenuItem(
        child: Text(assetType),
        value: assetType,
      ));
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  var _selectedEmployee;

  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      var email = auth.currentUser.email;
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) {
        _selectedEmployee = snapshot.docs.first.reference;
      });
    }
    _loadAssetTypes();
    print(_assetTypes);
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController _assetNameFieldController =
        new TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Assign New Asset',
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
                  DropdownButtonFormField(
                    items: _assetTypes,
                    value: _selectedType,
                    hint: Text("Select Type"),
                    onChanged: (value) {
                      _selectedType = value;
                    },
                  ),
                  TextFormField(
                    controller: _assetNameFieldController,
                    decoration: InputDecoration(
                      hintText: "Enter asset name",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                if (_shoppingItemAddFormkey.currentState.validate()) {
                  Request request = new Request(
                    _assetNameFieldController.text.toString(),
                    _selectedType,
                    _selectedEmployee,
                  );
                  addItem(request);
                  // Alert dialog close
                  Navigator.of(context).pop();
                }
              },
              elevation: 5.0,
              child: Text('Assing'),
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
                  label: Text("Assign New Asset"),
                ),
                SizedBox(height: defaultPadding),
                MyRequestsList(),
                SizedBox(height: defaultPadding),
                if (Responsive.isMobile(context))
                  SizedBox(height: defaultPadding),
              ],
            ),
          ),
          if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
          // On Mobile means if the screen is less than 850 we dont want to show it
        ],
      ),
    );
  }
}
