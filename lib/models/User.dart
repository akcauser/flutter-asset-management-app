import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email, name, role;
  String image = 'assets/icons/xd_file.svg';

  User(email, name, role) {
    this.email = email;
    this.name = name;
    this.role = role;
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'email': email,
      'name': name,
      'role': role,
    };
  }

  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['image'] = image;
    mapping['email'] = email;
    mapping['name'] = name;
    mapping['role'] = role;

    return mapping;
  }

  DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['image'] != null),
        assert(map['email'] != null),
        assert(map['name'] != null),
        assert(map['role'] != null),
        image = map['image'],
        email = map['email'],
        name = map['name'],
        role = map['role'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
