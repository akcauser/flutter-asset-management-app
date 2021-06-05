import 'package:admin/models/Asset.dart';
import 'package:admin/models/AssetType.dart';
import 'package:admin/models/User.dart';
import 'package:admin/screens/assets/components/digital_assets_list.dart';
import 'package:admin/screens/assets/components/physical_assets_list.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:admin/screens/assets/components/human_assets_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class AssetsScreen extends StatefulWidget {
  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final _shoppingItemAddFormkey = GlobalKey<FormState>();
  CollectionReference assetsCollection =
      FirebaseFirestore.instance.collection('assets');
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addItem(Asset asset) {
    var data = {
      'name': asset.name,
      'type': asset.type,
      'userReference': asset.userReference,
      'createdAt': asset.createdAt,
    };
    if (asset.type == "Physical") {
      data.putIfAbsent("serialNumber", () => asset.serialNumber);
    } else if (asset.type == "Digital") {
      data.putIfAbsent("licenseKey", () => asset.licenseKey);
    } else {
      data.putIfAbsent("humanReference", () => asset.humanReference);
    }

    return assetsCollection
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

  var _selectedEmployee;
  var _selectedHuman;
  var _users = List<DropdownMenuItem>();
  _loadUsers() {
    usersCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _users.add(DropdownMenuItem(
          child: Text(User.fromSnapshot(result).name),
          value: User.fromSnapshot(result).reference,
        ));
      });
    });
  }

  void initState() {
    super.initState();
    _loadUsers();
    _loadAssetTypes();
    print(_assetTypes);
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController _assetNameFieldController =
        new TextEditingController();
    TextEditingController _physicalAssetSerialNumberFieldController =
        new TextEditingController();
    TextEditingController _digitalAssetLicenseKeyFieldController =
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
                      setState(() {
                        _selectedType = value;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    items: _users,
                    value: _selectedEmployee,
                    hint: Text("Select Employee"),
                    onChanged: (value) {
                      _selectedEmployee = value;
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
                  Visibility(
                    visible: _selectedType == "Physical",
                    child: TextFormField(
                      controller: _physicalAssetSerialNumberFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter serial number",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (_selectedType == 'Physical' && value.isEmpty) {
                          return "Please enter serial number";
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: _selectedType == "Digital",
                    child: TextFormField(
                      controller: _digitalAssetLicenseKeyFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter license key",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (_selectedType == 'Physical' && value.isEmpty) {
                          return "Please enter license key";
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: _selectedType == "Human",
                    child: DropdownButtonFormField(
                      items: _users,
                      value: _selectedHuman,
                      hint: Text("Human"),
                      onChanged: (value) {
                        _selectedHuman = value;
                      },
                    ),
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
                  Asset asset = new Asset(
                    _assetNameFieldController.text.toString(),
                    _selectedType,
                    _physicalAssetSerialNumberFieldController.text.toString(),
                    _selectedEmployee,
                    _digitalAssetLicenseKeyFieldController.text.toString(),
                    _selectedHuman,
                  );
                  addItem(asset);
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
                PhysicalAssetsList(),
                SizedBox(height: defaultPadding),
                DigitalAssetsList(),
                SizedBox(height: defaultPadding),
                HumanAssetsList(),
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
