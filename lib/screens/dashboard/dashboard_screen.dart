import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/pending_requests_list.dart';
import 'package:admin/screens/layouts/app_layout.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/asset_counts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                if (Responsive.isMobile(context)) AssetCounts(),
              ],
            ),
          ),
          if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
          // On Mobile means if the screen is less than 850 we dont want to show it
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 2,
              child: AssetCounts(),
            ),
        ],
      ),
    );
  }
}
