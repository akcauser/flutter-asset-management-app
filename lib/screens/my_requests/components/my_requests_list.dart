import 'package:admin/models/Request.dart';
import 'package:admin/models/User.dart' as MyUser;
import 'package:admin/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyRequestsList extends StatefulWidget {
  MyRequestsList({
    Key key,
  }) : super(key: key);

  @override
  _MyRequestsListState createState() => _MyRequestsListState();
}

class _MyRequestsListState extends State<MyRequestsList> {
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  FirebaseAuth auth = FirebaseAuth.instance;
  var _userReference;
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      var email = auth.currentUser.email;
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) {
        setState(() {
          _userReference = snapshot.docs.first.reference;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: requestsCollection
            .where('type', whereIn: ['Digital', 'Physical', 'Human'])
            .where('userReference', isEqualTo: _userReference ?? "")
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
                  "My Requests",
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
                          label: Text("Time"),
                        ),
                        DataColumn(
                          label: Text("Status"),
                        ),
                      ],
                      rows: _createRows(snapshot.data),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Future<void> deleteItem(itemReference) {
    return requestsCollection
        .doc(itemReference)
        .delete()
        .then((value) => print('item deleted'))
        .catchError((error) => print('error occured'));
  }

  final request = Request.fromSnapshot(documentSnapshot);
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Visibility(
              visible: request.status == "Pending",
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  deleteItem(request.reference.id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(request.name),
            ),
          ],
        ),
      ),
      DataCell(Text(request.type)),
      DataCell(Text(request.createdAt.toDate().toString())),
      DataCell(
        Text(
          request.status,
          style: TextStyle(
            backgroundColor: request.status == "Accepted"
                ? Colors.green
                : request.status == "Pending"
                    ? Colors.orange
                    : Colors.red,
          ),
        ),
      ),
    ],
  );
}
