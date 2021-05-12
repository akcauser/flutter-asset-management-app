import 'package:admin/responsive.dart';
import 'package:admin/screens/layouts/header.dart';
import 'package:admin/screens/layouts/side_menu.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/MenuController.dart';
import 'components/my_fiels.dart';
import 'components/recent_files.dart';
import 'components/storage_details.dart';

import 'package:provider/provider.dart';

import '../layouts/side_menu.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child: Scaffold(
        drawer: SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: SideMenu(),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Header(),
                        SizedBox(height: defaultPadding),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  MyFiels(),
                                  SizedBox(height: defaultPadding),
                                  RecentFiles(),
                                  if (Responsive.isMobile(context))
                                    SizedBox(height: defaultPadding),
                                  if (Responsive.isMobile(context))
                                    StarageDetails(),
                                ],
                              ),
                            ),
                            if (!Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            // On Mobile means if the screen is less than 850 we dont want to show it
                            if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: StarageDetails(),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
