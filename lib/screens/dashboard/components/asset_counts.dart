import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import 'asset_chart.dart';

class AssetCounts extends StatefulWidget {
  const AssetCounts({
    Key key,
  }) : super(key: key);

  @override
  _AssetCountsState createState() => _AssetCountsState();
}

class _AssetCountsState extends State<AssetCounts> {
  var _physicalRequestCount = 0;
  var _physicalAssetCount = 0;
  var _digitalRequestCount = 0;
  var _digitalAssetCount = 0;
  var _humanRequestCount = 0;
  var _humanAssetCount = 0;
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: "Physical")
        .get()
        .then((snapshot) {
      setState(() {
        _physicalRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: "Physical")
        .get()
        .then((snapshot) {
      setState(() {
        _physicalAssetCount = snapshot.size;
      });
    });
    // Digital
    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: "Digital")
        .get()
        .then((snapshot) {
      setState(() {
        _digitalRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: "Digital")
        .get()
        .then((snapshot) {
      setState(() {
        _digitalAssetCount = snapshot.size;
      });
    });
    // Human
    FirebaseFirestore.instance
        .collection('requests')
        .where('type', isEqualTo: "Human")
        .get()
        .then((snapshot) {
      setState(() {
        _humanRequestCount = snapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('assets')
        .where('type', isEqualTo: "Human")
        .get()
        .then((snapshot) {
      setState(() {
        _humanAssetCount = snapshot.size;
      });
    });
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
            "Asset Counts",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          AssetChart(),
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
                  child: SvgPicture.asset("assets/icons/Documents.svg"),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Physical Assets",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$_physicalRequestCount Request",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(_physicalAssetCount.toString())
              ],
            ),
          ),
          // Digital
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
                          "Digital Assets",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$_digitalRequestCount Request",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(_digitalAssetCount.toString())
              ],
            ),
          ),
          // Human
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
                  child: SvgPicture.asset("assets/icons/folder.svg"),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Human Asset",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$_humanRequestCount Request",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(_humanAssetCount.toString())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
