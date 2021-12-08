import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/error_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'components/vendors_card.dart';
import 'vendors_details.dart';

class VendorsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final vendorsState = watch(vendorsNotifierProvider.state);
    return Scaffold(
        appBar: AppBar(
          title: Text("Vendors"),
        ),
        body: vendorsState is VendorsLoadedState
            ? ListView.builder(
                padding: EdgeInsets.only(top: 5),
                itemCount: vendorsState.vendorsList.length,
                itemBuilder: (context, index) {
                  return VendorCard(
                    logo: vendorsState.vendorsList[index].image,
                    verifiedText: vendorsState.vendorsList[index].verifiedText,
                    name: vendorsState.vendorsList[index].name,
                    isVerified: vendorsState.vendorsList[index].verified,
                    rating: vendorsState.vendorsList[index].rating,
                    onTap: () {
                      context
                          .read(vendorDetailsNotifierProvider)
                          .getVendorDetails(
                              vendorsState.vendorsList[index].slug);
                      context
                          .read(vendorItemsNotifierProvider)
                          .getVendorItems(vendorsState.vendorsList[index].slug);
                      context.nextPage(VendorsDetailsScreen());
                    },
                  );
                })
            : vendorsState is VendorsErrorState
                ? ErrorMessageWidget(vendorsState.message)
                : Container());
  }
}
