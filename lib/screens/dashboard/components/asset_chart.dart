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
  var _totalRequestCount = 0;
  var _physicalRequestCount = 1;
  var _digitalRequestCount = 1;
  var _humanRequestCount = 1;
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('requests').get().then((snapshot) {
      setState(() {
        _totalRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: 'Physical')
        .get()
        .then((snapshot) {
      setState(() {
        _physicalRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: 'Digital')
        .get()
        .then((snapshot) {
      setState(() {
        _digitalRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: 'Human')
        .get()
        .then((snapshot) {
      setState(() {
        _humanRequestCount = snapshot.size;
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
                  value: _physicalRequestCount.toDouble(),
                  showTitle: false,
                  radius: _physicalRequestCount.toDouble(),
                ),
                PieChartSectionData(
                  color: Color(0xFF26E5FF),
                  value: _digitalRequestCount.toDouble(),
                  showTitle: false,
                  radius: _digitalRequestCount.toDouble(),
                ),
                PieChartSectionData(
                  color: Color(0xFFFFCF26),
                  value: _humanRequestCount.toDouble(),
                  showTitle: false,
                  radius: _humanRequestCount.toDouble(),
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
                  _totalRequestCount.toString(),
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
