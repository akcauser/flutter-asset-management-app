import 'package:admin/screens/layouts/app_layout.dart';
import 'package:admin/screens/my_profile/components/profile_detail.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
                ProfileDetail(),
                SizedBox(height: defaultPadding),
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
