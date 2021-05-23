import 'package:admin/models/Asset.dart';
import 'package:admin/screens/my_assets/components/my_digital_assets_list.dart';
import 'package:admin/screens/my_assets/components/my_physical_assets_list.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:admin/screens/my_assets/components/my_human_assets_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class MyAssetsScreen extends StatefulWidget {
  @override
  _MyAssetsScreenState createState() => _MyAssetsScreenState();
}

class _MyAssetsScreenState extends State<MyAssetsScreen> {
  CollectionReference assetsCollection =
      FirebaseFirestore.instance.collection('assets');

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

  void initState() {
    super.initState();
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
                SizedBox(height: defaultPadding),
                MyPhysicalAssetsList(),
                SizedBox(height: defaultPadding),
                MyDigitalAssetsList(),
                SizedBox(height: defaultPadding),
                MyHumanAssetsList(),
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
