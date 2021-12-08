import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/data/models/vendors/vendor_details_model.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'components/vendors_activity_card.dart';
import 'components/vendors_card.dart';

class VendorsAboutUsScreen extends StatelessWidget {
  final VendorDetails vendorDetails;
  final VoidCallback onPressedContact;

  VendorsAboutUsScreen(
      {@required this.vendorDetails, @required this.onPressedContact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: context.screenHeight * .30,
              width: context.screenWidth,
              child: Image.network(vendorDetails.bannerImage, errorBuilder:
                  (BuildContext _, Object error, StackTrace stack) {
                return Container();
              }, fit: BoxFit.cover),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                VendorCard(
                  logo: vendorDetails.image,
                  name: vendorDetails.name,
                  verifiedText: vendorDetails.verifiedText,
                  isVerified: vendorDetails.verified,
                  rating: vendorDetails.rating,
                  trailingEnabled: false,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      tooltip: "Contact Shop",
                      color: kDarkColor,
                      onPressed: onPressedContact,
                      icon: Icon(CupertinoIcons.bubble_left),
                    ),
                  ),
                )
              ],
            ),
            VendorsActivityCard(
              activeListCount: vendorDetails.activeListingsCount ?? 0,
              rating: vendorDetails.rating ?? '0',
              itemsSold: vendorDetails.soldItemCount ?? 0,
            ),
            Container(
              color: kLightColor,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description", style: context.textTheme.bodyText2),
                  ResponsiveTextWidget(
                      title: vendorDetails.description,
                      textStyle: context.textTheme.caption
                          .copyWith(color: kDarkColor.withOpacity(0.75)))
                ],
              ),
            ).cornerRadius(10).p(10),
          ],
        ),
      ),
    );
  }
}
