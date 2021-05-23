import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String name, type, status;
  Timestamp createdAt;
  DocumentReference userReference;

  Request(name, type, userReference) {
    this.name = name;
    this.type = type;
    this.userReference = userReference;
    this.createdAt = Timestamp.now();
    this.status = "Pending";
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'userReference': userReference,
      'createdAt': createdAt,
      'status': status,
    };
  }

  DocumentReference reference;

  Request.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['type'] != null),
        assert(map['userReference'] != null),
        assert(map['createdAt'] != null),
        assert(map['status'] != null),
        name = map['name'],
        type = map['type'],
        userReference = map['userReference'],
        createdAt = map['createdAt'],
        status = map['status'];

  Request.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
