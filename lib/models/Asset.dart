import 'package:cloud_firestore/cloud_firestore.dart';

class Asset {
  String name, type;
  Timestamp createdAt;
  DocumentReference userReference;
  String serialNumber;
  String licenseKey;
  DocumentReference humanReference;

  Asset(name, type, serialNumber, userReference, licenseKey, humanReference) {
    this.name = name;
    this.type = type;
    this.userReference = userReference;
    this.createdAt = Timestamp.now();
    this.serialNumber = serialNumber;
    this.licenseKey = licenseKey;
    this.humanReference = humanReference;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'userReference': userReference,
      'createdAt': createdAt,
      'serialNumber': serialNumber,
      'licenseKey': licenseKey,
      'humanReference': humanReference,
    };
  }

  DocumentReference reference;

  Asset.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['type'] != null),
        assert(map['userReference'] != null),
        assert(map['createdAt'] != null),
        name = map['name'],
        type = map['type'],
        userReference = map['userReference'],
        createdAt = map['createdAt'],
        licenseKey = map['licenseKey'],
        serialNumber = map['serialNumber'],
        humanReference = map['humanReference'];

  Asset.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
