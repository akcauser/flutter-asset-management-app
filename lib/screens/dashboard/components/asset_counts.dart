import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'asset_chart.dart';
import 'asset_info_card.dart';

class AssetCounts extends StatelessWidget {
  const AssetCounts({
    Key key,
  }) : super(key: key);

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
          AssetInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Physical Assets",
            amountOfFiles: "2",
            numOfFiles: 3,
          ),
          AssetInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Digital Assets",
            amountOfFiles: "0",
            numOfFiles: 2,
          ),
          AssetInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Human Asset",
            amountOfFiles: "1",
            numOfFiles: 2,
          ),
        ],
      ),
    );
  }
}
