import 'package:admin/models/Asset.dart';
import 'package:admin/models/Request.dart';
import 'package:admin/models/User.dart' as MyUser;
import 'package:admin/models/User.dart';
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
                      rows: _createRows(snapshot.data, context),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

List<DataRow> _createRows(QuerySnapshot snapshot, BuildContext context) {
  List<DataRow> newList =
      snapshot.docs.map((DocumentSnapshot documentSnapshot) {
    return _createRow(documentSnapshot, context);
  }).toList();

  return newList;
}

DataRow _createRow(DocumentSnapshot documentSnapshot, BuildContext context) {
  final _formkey = GlobalKey<FormState>();
  CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');
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

  _loadUsers();

  Future<String> createAlertDialog(Request request) {
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
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: request.type == "Physical",
                    child: TextFormField(
                      controller: _physicalAssetSerialNumberFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter serial number",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (request.type == 'Physical' && value.isEmpty) {
                          return "Please enter serial number";
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: request.type == "Digital",
                    child: TextFormField(
                      controller: _digitalAssetLicenseKeyFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter license key",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (request.type == 'Physical' && value.isEmpty) {
                          return "Please enter license key";
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: request.type == "Human",
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
                if (_formkey.currentState.validate()) {
                  Asset asset = new Asset(
                    request.name,
                    request.type,
                    _physicalAssetSerialNumberFieldController.text.toString(),
                    request.userReference,
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
            Visibility(
              visible: request.status == "Pending",
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.yellow,
                onPressed: () {
                  rejectItem(request.reference.id);
                },
              ),
            ),
            Visibility(
              visible: request.status == "Pending",
              child: IconButton(
                icon: Icon(Icons.check),
                color: Colors.green,
                onPressed: () {
                  acceptItem(request.reference.id);
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
            createAlertDialog(request);
          },
          icon: Icon(Icons.assignment),
          label: Text("Assign"),
        ),
      ),
    ],
  );
}
