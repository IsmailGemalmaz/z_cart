import 'package:flutter/material.dart';
import 'package:zcart/riverpod/providers/offers_provider.dart';
import 'package:zcart/riverpod/state/product/product_state.dart';
import 'package:zcart/views/screens/product_details/offers_screen.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreOffersFromSellerCard extends StatelessWidget {
  const MoreOffersFromSellerCard({@required this.productDetailsState});

  final ProductLoadedState productDetailsState;

  @override
  Widget build(BuildContext context) {
    return productDetailsState.productModel.data.product.listingCount == 0 ||
            productDetailsState.productModel.data.product.listingCount == null
        ? Container()
        : Container(
            color: kLightColor,
            child: ListTile(
              title: Text(
                "More (${productDetailsState.productModel.data.product.listingCount}) offers from other sellers ",
                style: context.textTheme.subtitle2.copyWith(color: kDarkColor),
              ),
              onTap: () {
                context.read(offersNotifierProvider).getOffersFromOtherSellers(
                    productDetailsState.productModel.data.product.slug);
                context.nextPage(OffersScreen());
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ));
  }
}
