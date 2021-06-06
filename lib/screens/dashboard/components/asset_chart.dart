import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AssetChart extends StatefulWidget {
  const AssetChart({
    Key key,
  }) : super(key: key);

  @override
  _AssetChartState createState() => _AssetChartState();
}

class _AssetChartState extends State<AssetChart> {
  var _totalAssetCount = 0;
  var _physicalAssetCount = 1.0;
  var _digitalAssetCount = 1.0;
  var _humanAssetCount = 1.0;
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('assets').get().then((snapshot) {
      setState(() {
        _totalAssetCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: 'Physical')
        .get()
        .then((snapshot) {
      setState(() {
        _physicalAssetCount = snapshot.size.toDouble();
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: 'Digital')
        .get()
        .then((snapshot) {
      setState(() {
        _digitalAssetCount = snapshot.size.toDouble();
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: 'Human')
        .get()
        .then((snapshot) {
      setState(() {
        _humanAssetCount = snapshot.size.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: primaryColor,
                  showTitle: true,
                  value: 1,
                  title: _physicalAssetCount.toString(),
                  radius: 2,
                ),
                PieChartSectionData(
                  color: Color(0xFF26E5FF),
                  showTitle: true,
                  value: 1,
                  title: _digitalAssetCount.toString(),
                  radius: 2,
                ),
                PieChartSectionData(
                  color: Color(0xFFFFCF26),
                  showTitle: true,
                  value: 1,
                  title: _humanAssetCount.toString(),
                  radius: 2,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  _totalAssetCount.toString(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
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
