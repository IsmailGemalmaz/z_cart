import 'package:flutter/material.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

class VendorsActivityCard extends StatelessWidget {
  final int activeListCount;
  final String rating;
  final int itemsSold;

  VendorsActivityCard(
      {@required this.activeListCount,
      @required this.rating,
      @required this.itemsSold});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$activeListCount",
                          style: context.textTheme.headline4
                              .copyWith(color: kPrimaryColor)),
                      Text("Activity Listings",
                          textAlign: TextAlign.center,
                          style: context.textTheme.subtitle2
                              .copyWith(color: kDarkColor))
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(rating,
                          style: context.textTheme.headline4
                              .copyWith(color: kPrimaryColor)),
                      Text("Rating",
                          textAlign: TextAlign.center,
                          style: context.textTheme.subtitle2
                              .copyWith(color: kDarkColor))
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$itemsSold",
                          style: context.textTheme.headline4
                              .copyWith(color: kPrimaryColor)),
                      Text("Items Sold",
                          textAlign: TextAlign.center,
                          style: context.textTheme.subtitle2
                              .copyWith(color: kDarkColor))
                    ],
                  )),
            ],
          ).py(10).px(10),
        ],
      ),
    ).cornerRadius(10).p(10);
  }
}
