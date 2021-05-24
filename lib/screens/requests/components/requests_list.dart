import 'package:admin/models/Request.dart';
import 'package:admin/models/User.dart' as MyUser;
import 'package:admin/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class RequestsList extends StatefulWidget {
  RequestsList({
    Key key,
  }) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: requestsCollection
            .where('type', whereIn: ['Digital', 'Physical', 'Human']).snapshots(
                includeMetadataChanges: true),
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
                  "Requests from Employees",
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
                        DataColumn(
                          label: Text("Action"),
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
  final _formkey = GlobalKey<FormState>();
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Future<void> rejectItem(itemReference) {
    return requestsCollection
        .doc(itemReference)
        .update({'status': 'Rejected'})
        .then((value) => print('item rejected'))
        .catchError((error) => print('error occured'));
  }

  Future<void> acceptItem(itemReference) {
    return requestsCollection
        .doc(itemReference)
        .update({'status': 'Accepted'})
        .then((value) => print('item accepted'))
        .catchError((error) => print('error occured'));
  }

  final request = Request.fromSnapshot(documentSnapshot);
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.close),
              color: Colors.yellow,
              onPressed: () {
                rejectItem(request.reference.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              color: Colors.green,
              onPressed: () {
                acceptItem(request.reference.id);
              },
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
      DataCell(Text(
        request.status,
        style: TextStyle(
          backgroundColor:
              request.status == "Accepted" ? Colors.green : Colors.red,
        ),
      )),
      DataCell(
        ElevatedButton.icon(
          onPressed: () {
            //assignRequestAsAsset(request);
          },
          icon: Icon(Icons.assignment),
          label: Text("Assign"),
        ),
      ),
    ],
  );
}
