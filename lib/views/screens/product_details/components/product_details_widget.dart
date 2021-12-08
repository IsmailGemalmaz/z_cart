import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/riverpod/state/product/product_state.dart';
import 'package:zcart/Theme/styles/colors.dart';

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({@required this.productDetailsState});

  final ProductLoadedState productDetailsState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: kLightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productDetailsState.productModel.data.keyFeatures.isEmpty
                  ? Container()
                  : Text('Key Features\n', style: context.textTheme.subtitle2),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      productDetailsState.productModel.data.keyFeatures.length,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 10,
                        ).p(8).pOnly(right: 5),
                        Flexible(
                          child: Text(
                            productDetailsState
                                .productModel.data.keyFeatures[index],
                            style: context.textTheme.bodyText2
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ).pSymmetric(v: 2);
                  }),
              Text('\nTechnical Details\n', style: context.textTheme.subtitle2),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Brand: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.product.brand ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Model No.: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.product.modelNumber ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("ISBN: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.product.gtin ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Part No.: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.product.mpn ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Seller SKU: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState.productModel.data.sku ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Manufacturer: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState.productModel.data.product
                                      .manufacturer.name ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Origin: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.product.origin ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Minimum quantity: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.minOrderQuantity
                                      .toString() ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Shipping Weight: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState
                                      .productModel.data.shippingWeight ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Added on: ")),
                      Expanded(
                          flex: 3,
                          child: Text(
                              productDetailsState.productModel.data.product
                                      .availableFrom ??
                                  "Not Available",
                              style: context.textTheme.bodyText2)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ).cornerRadius(10).p(10),
        productDetailsState.productModel.data.product.description == null
            ? Container()
            : Container(
                color: kLightColor,
                child: ExpansionTile(
                  title: Text('Product Description',
                      style: context.textTheme.subtitle2),
                  iconColor: kDarkColor,
                  collapsedIconColor: kPrimaryColor,
                  children: [
                    HtmlWidget(
                      productDetailsState.productModel.data.product.description,
                      enableCaching: true,
                      webView: true,
                      webViewJs: true,
                      webViewMediaPlaybackAlwaysAllow: true,
                    ).px(10).py(5),
                  ],
                ),
              ).cornerRadius(10).p(10),
        productDetailsState.productModel.data.description == null
            ? Container()
            : Container(
                color: kLightColor,
                child: ExpansionTile(
                  title: Text('Seller Specification',
                      style: context.textTheme.subtitle2),
                  iconColor: kDarkColor,
                  collapsedIconColor: kPrimaryColor,
                  children: [
                    HtmlWidget(
                      productDetailsState.productModel.data.description,
                      enableCaching: true,
                      webView: true,
                      webViewMediaPlaybackAlwaysAllow: true,
                    ).px(10).py(5),
                  ],
                ),
              ).cornerRadius(10).px(10),
      ],
    );
  }
}
