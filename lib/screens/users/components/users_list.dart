import 'package:admin/models/RecentFile.dart';
import 'package:admin/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class UsersList extends StatelessWidget {
  UsersList({
    Key key,
  }) : super(key: key);

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // ekleme
  Future<void> addItem(text) {
    return usersCollection
        .add({'text': text})
        .then((value) => print('item added'))
        .catchError((error) => print('error occured'));
  }

  // silme
  Future<void> deleteItem(itemReference) {
    return usersCollection
        .doc(itemReference)
        .delete()
        .then((value) => print('item deleted'))
        .catchError((error) => print('error occured'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
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
                  "My Active Assets",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    horizontalMargin: 0,
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Asset Name"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Size"),
                      ),
                    ],
                    rows: _buildList(context, snapshot.data.docs),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

List<DataRow> _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

DataRow _buildListItem(
    BuildContext context, DocumentSnapshot documentSnapshot) {
  final user = User.fromSnapshot(documentSnapshot);
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              user.image,
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(user.email),
            ),
          ],
        ),
      ),
      DataCell(Text(user.name)),
      DataCell(Text(user.role)),
    ],
  );
}
