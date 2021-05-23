import 'package:admin/models/Asset.dart';
import 'package:admin/models/User.dart';
import 'package:admin/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class PhysicalAssetsList extends StatefulWidget {
  PhysicalAssetsList({
    Key key,
  }) : super(key: key);

  @override
  _PhysicalAssetsListState createState() => _PhysicalAssetsListState();
}

class _PhysicalAssetsListState extends State<PhysicalAssetsList> {
  CollectionReference assetsCollection =
      FirebaseFirestore.instance.collection('assets');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: assetsCollection
          .where('type', isEqualTo: 'Physical')
          .snapshots(includeMetadataChanges: true),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Something went wrong');
        }

        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting)
          return LinearProgressIndicator();

        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Physical Assets",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Responsive.isMobile(context)
                      ? Axis.horizontal
                      : Axis.vertical,
                  child: DataTable(
                    horizontalMargin: 0,
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Name"),
                      ),
                      DataColumn(
                        label: Text("Type"),
                      ),
                      DataColumn(
                        label: Text("Serial Number"),
                      ),
                      DataColumn(
                        label: Text("Employee"),
                      ),
                      DataColumn(
                        label: Text("Time"),
                      ),
                    ],
                    rows: _createRows(snapshot.data),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

List<DataRow> _createRows(QuerySnapshot snapshot) {
  List<DataRow> newList =
      snapshot.docs.map((DocumentSnapshot documentSnapshot) {
    return _createRow(documentSnapshot);
  }).toList();

  return newList;
}

DataRow _createRow(DocumentSnapshot documentSnapshot) {
  CollectionReference assetsCollection =
      FirebaseFirestore.instance.collection('assets');
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> deleteItem(itemReference) {
    return assetsCollection
        .doc(itemReference)
        .delete()
        .then((value) => print('item deleted'))
        .catchError((error) => print('error occured'));
  }

  final asset = Asset.fromSnapshot(documentSnapshot);

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                deleteItem(asset.reference.id);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(asset.name),
            ),
          ],
        ),
      ),
      DataCell(Text(asset.type)),
      DataCell(Text(asset.serialNumber ?? '-')),
      DataCell(
        StreamBuilder<DocumentSnapshot>(
            stream: asset.userReference.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text("-");
              }

              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();

              return Text(User.fromSnapshot(snapshot.data).name);
            }),
      ),
      DataCell(Text(asset.createdAt.toDate().toString())),
    ],
  );
}
