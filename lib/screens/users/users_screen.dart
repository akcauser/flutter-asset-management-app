import 'package:admin/screens/dashboard/components/storage_details.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:admin/screens/users/components/users_list.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
                SizedBox(height: defaultPadding),
                UsersList(),
                if (Responsive.isMobile(context))
                  SizedBox(height: defaultPadding),
                if (Responsive.isMobile(context)) StarageDetails(),
              ],
            ),
          ),
          if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
          // On Mobile means if the screen is less than 850 we dont want to show it
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 2,
              child: StarageDetails(),
            ),
        ],
      ),
    );
  }
}
