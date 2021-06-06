import 'package:admin/responsive.dart';
import 'package:admin/screens/my_dashboard/components/pending_requests_list.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MyDashboardScreen extends StatefulWidget {
  @override
  _MyDashboardScreenState createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen> {
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
                PendingRequestsList(),
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
