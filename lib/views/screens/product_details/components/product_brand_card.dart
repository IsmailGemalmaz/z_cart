import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/riverpod/providers/brand_provider.dart';
import 'package:zcart/riverpod/state/product/product_state.dart';
import 'package:zcart/views/screens/brand/brand_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductBrandCard extends StatelessWidget {
  final ProductLoadedState productDetailsState;

  ProductBrandCard(this.productDetailsState);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: productDetailsState.productModel.data.product.manufacturer.slug ==
              null
          ? Container()
          : Container(
              color: kLightColor,
              child: ListTile(
                title: Text(
                  "Brand  :  ${productDetailsState.productModel.data.product.manufacturer.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      context.textTheme.subtitle2.copyWith(color: kDarkColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () async {
                  context.nextPage(BrandProfileScreen());
                  await context
                      .read(brandProfileNotifierProvider)
                      .getBrandProfile(productDetailsState
                          .productModel.data.product.manufacturer.slug);

                  await context
                      .read(brandItemsListNotifierProvider)
                      .getBrandItemsList(productDetailsState
                          .productModel.data.product.manufacturer.slug);
                },
              ),
            ),
    );
  }
}
