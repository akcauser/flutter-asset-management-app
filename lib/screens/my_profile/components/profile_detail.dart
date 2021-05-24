import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/User.dart' as MyUser;
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({
    Key key,
  }) : super(key: key);

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  FirebaseAuth auth = FirebaseAuth.instance;
  MyUser.User user;
  @override
  void initState() {
    getData();
    super.initState();
  }

  var _userName = "";
  var _userEmail = "";
  var _userRole = "";
  Future<void> getData() async {
    if (auth.currentUser != null) {
      var email = auth.currentUser.email;
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print("user detail initstate");
          user = MyUser.User.fromSnapshot(result);
          setState(() {
            _userName = user.name;
            _userEmail = user.email;
            _userRole = user.role;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "My Profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Container(
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultPadding),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset("assets/icons/media.svg"),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _userName,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultPadding),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset("assets/icons/media.svg"),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _userEmail,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: defaultPadding),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultPadding),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset("assets/icons/media.svg"),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Role",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _userRole,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
