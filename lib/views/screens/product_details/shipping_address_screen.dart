import 'package:flutter/material.dart';
import 'package:zcart/data/models/product/product_details_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/riverpod/providers/address_provider.dart';
import 'package:zcart/riverpod/providers/product_provider.dart';
import 'package:zcart/riverpod/state/address/address_state.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({@required this.productModel});

  final ProductDetailsModel productModel;

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  var selectedCountry;
  var selectedShippingMethod;

  @override
  Widget build(BuildContext context) {
    return ProviderListener<ShippingState>(
        provider: shippingNotifierProvider.state,
        onChange: (context, state) {
          if (state is ShippingOptionsLoadedState) {
            widget.productModel.shippingOptions = state.shippingOptions
                .map((e) => ShippingOption.fromJson(e.toJson()))
                .toList();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
              title: Text("Shipping Address"),
              centerTitle: true,
              backgroundColor: kLightColor,
              elevation: 0),
          body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
              color: kLightColor,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ship to", style: context.textTheme.bodyText2)
                      .pOnly(bottom: 10),
                  Container(
                    color: kPrimaryColor.withOpacity(0.10),
                    padding: EdgeInsets.only(left: 10),
                    width: context.screenWidth,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        focusColor: kLightColor,
                        value: selectedCountry ??
                            widget.productModel.countries.values.elementAt(
                                widget.productModel.countries.keys
                                    .toList()
                                    .indexOf(widget
                                        .productModel.shippingCountryId
                                        .toString())),
                        style: TextStyle(color: kLightColor),
                        iconEnabledColor: kPrimaryColor,
                        items: widget.productModel.countries.entries
                            .map((e) => e.value)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: kPrimaryColor)));
                        }).toList(),
                        hint: Text("Select options",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        onChanged: (String value) {
                          setState(() {
                            selectedCountry = value;
                          });
                          context
                              .read(shippingNotifierProvider)
                              .fetchShippingOptions(
                                  widget.productModel.data.id,
                                  widget.productModel.countries.keys.elementAt(
                                      widget.productModel.countries.values
                                          .toList()
                                          .indexOf(selectedCountry.toString())),
                                  null);
                          widget.productModel.shippingCountryId = int.parse(
                              widget.productModel.countries.keys.elementAt(
                                  widget.productModel.countries.values
                                      .toList()
                                      .indexOf(selectedCountry.toString())));
                          context
                              .read(productNotifierProvider)
                              .updateState(widget.productModel);
                        },
                      ),
                    ),
                  ).cornerRadius(5).pOnly(bottom: 10),
                  Text("Shipping method", style: context.textTheme.bodyText2)
                      .pOnly(bottom: 10),
                  Container(
                    color: kPrimaryColor.withOpacity(0.10),
                    padding: EdgeInsets.only(left: 10),
                    width: context.screenWidth,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        focusColor: kLightColor,
                        value: selectedShippingMethod ??
                            widget.productModel.shippingOptions.first.name,
                        style: TextStyle(color: kLightColor),
                        iconEnabledColor: kPrimaryColor,
                        items: widget.productModel.shippingOptions
                            .map((e) => e.name)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: kPrimaryColor)));
                        }).toList(),
                        hint: Text("Select options",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        onChanged: (String value) {
                          setState(() {
                            selectedShippingMethod = value;
                          });

                          widget.productModel.shippingOptions.insert(
                              0,
                              widget.productModel.shippingOptions[widget
                                  .productModel.shippingOptions
                                  .map((e) => e.name)
                                  .toList()
                                  .indexOf(selectedShippingMethod)]);
                          widget.productModel.shippingOptions = widget
                              .productModel.shippingOptions
                              .toSet()
                              .toList();
                          context
                              .read(productNotifierProvider)
                              .updateState(widget.productModel);
                        },
                      ),
                    ),
                  ).cornerRadius(5).pOnly(bottom: 10),
                ],
              ),
            ).p(10)),
          ),
        ));
  }
}
