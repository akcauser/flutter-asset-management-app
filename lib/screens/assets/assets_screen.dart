import 'package:admin/models/Asset.dart';
import 'package:admin/models/AssetType.dart';
import 'package:admin/screens/assets/components/digital_assets_list.dart';
import 'package:admin/screens/assets/components/phyical_assets_list.dart';
import 'package:admin/screens/dashboard/components/storage_details.dart';
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

  Future<void> addItem(Asset asset) {
    return assetsCollection
        .add({
          'name': asset.name,
          'type': asset.type,
          'serialNumber': asset.serialNumber,
          'employeeId': asset.userReference,
          'createdAt': asset.createdAt,
        })
        .then((value) => print('item added'))
        .catchError((error) => print('error occured'));
  }

  String _selectedRole;
  var _assetTypes = List<DropdownMenuItem>();
  _loadAssetTypes() {
    AssetType.getAssetTypes().forEach((assetType) {
      _assetTypes.add(DropdownMenuItem(
        child: Text(assetType),
        value: assetType,
      ));
    });
  }

  void initState() {
    super.initState();
    _loadAssetTypes();
    print(_assetTypes);
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController _userNameFieldController =
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
                  DropdownButtonFormField(
                    items: _assetTypes,
                    value: _selectedRole,
                    hint: Text("Type"),
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
                  Asset asset = new Asset(
                    'name',
                    'type',
                    'serialNumber',
                    'employeeId',
                    'licenseKey',
                    'humanId',
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
                if (Responsive.isMobile(context)) StarageDetails(),
              ],
            ),
          ),
          if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
          // On Mobile means if the screen is less than 850 we dont want to show it
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 2,
              child: StarageDetails(),
            ),
        ],
      ),
    );
  }
}
