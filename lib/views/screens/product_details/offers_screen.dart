import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/riverpod/providers/offers_provider.dart';
import 'package:zcart/riverpod/state/offers_state.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

class OffersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final offersState = watch(offersNotifierProvider.state);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          title: Text("Offers"),
          centerTitle: true,
          backgroundColor: kLightColor,
          elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: offersState is OffersLoadingState
              ? Container(
                  height: context.screenHeight - 100,
                  child: Center(child: LoadingWidget()))
              : offersState is OffersLoadedState
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          color: kLightColor,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Image.network(
                                      offersState.offersModel.data.image,
                                      errorBuilder: (BuildContext _,
                                          Object error, StackTrace stack) {
                                return Container();
                              }, fit: BoxFit.fitWidth)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                        offersState.offersModel.data.name,
                                        maxLines: null,
                                        softWrap: true,
                                        style: context.textTheme.bodyText2
                                            .copyWith(color: kDarkColor)),
                                  ),
                                ],
                              ).py(5),
                              Text(
                                  offersState.offersModel.data.brand ??
                                      "Not Available",
                                  style: context.textTheme.bodyText2),
                              Text(
                                  "${offersState.offersModel.data.gtinType ?? ""} : ${offersState.offersModel.data.gtin ?? "Not Available"}",
                                  style: context.textTheme.bodyText2
                                      .copyWith(color: kPrimaryColor)),
                            ],
                          ),
                        ).px(10),
                        ProductDetailsCard(
                                productList:
                                    offersState.offersModel.data.listings)
                            .px(10)
                      ],
                    )
                  : Container(),
        ),
      ),
    );
  }
}
