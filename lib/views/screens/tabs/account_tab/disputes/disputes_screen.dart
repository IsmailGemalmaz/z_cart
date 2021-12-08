import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/controller/chat/chat_controller.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/dispute/disputes_state.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/screens/tabs/account_tab/disputes/dispute_details_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/messages/vendor_chat_screen.dart';
import 'package:zcart/views/shared_widgets/loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:nb_utils/nb_utils.dart';

class DisputeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final disputesState = watch(disputesProvider.state);
    final scrollControllerProvider = watch(disputesScrollNotifierProvider);
    return ProviderListener<ScrollState>(
      provider: disputesScrollNotifierProvider.state,
      onChange: (context, state) {
        if (state is ScrollReachedBottomState) {
          context.read(disputesProvider).getMoreDisputes();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("Dispute"),
          actions: [
            Visibility(
                visible: disputesState is DisputesErrorState,
                child: IconButton(
                    onPressed: () {
                      context.read(disputesProvider).getDisputes();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                    )))
          ],
        ),
        body: disputesState is DisputesLoadingState
            ? Container(
                child: LoadingWidget(),
              ).center()
            : disputesState is DisputesErrorState
                ? Container(
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dangerous).paddingRight(5),
                        Text(disputesState.message),
                      ],
                    )),
                  )
                // ? ListTile(
                //     title: Text(disputesState.message,
                //         style: TextStyle(color: kPrimaryLightTextColor)),
                //     leading: Icon(Icons.dangerous),
                //     contentPadding: EdgeInsets.zero,
                //     horizontalTitleGap: 0,
                //   ).px(10)
                : disputesState is DisputesLoadedState
                    ? ListView.builder(
                        controller: scrollControllerProvider.controller,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: disputesState.disputes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: kLightColor,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            disputesState
                                                .disputes[index].shop.name,
                                            style: context.textTheme.bodyText2),
                                        Text(
                                            disputesState
                                                .disputes[index].updatedAt,
                                            style: context.textTheme.overline
                                                .copyWith(color: kDarkColor)),
                                      ],
                                    ).pOnly(bottom: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: disputesState
                                                      .disputes[index].status ==
                                                  'SOLVED'
                                              ? kGreenColor
                                              : kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                          disputesState.disputes[index].status,
                                          style: context.textTheme.overline
                                              .copyWith(
                                                  color:
                                                      kPrimaryLightTextColor)),
                                    )
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: disputesState.disputes[index]
                                      .orderDetails.items.length,
                                  itemBuilder: (context, itemsIndex) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          disputesState
                                              .disputes[index]
                                              .orderDetails
                                              .items[itemsIndex]
                                              .image,
                                          height: 50,
                                          width: 50,
                                          errorBuilder: (BuildContext context,
                                              Object error, StackTrace stack) {
                                            return Container();
                                          },
                                        ).pOnly(right: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        disputesState
                                                            .disputes[index]
                                                            .orderDetails
                                                            .items[itemsIndex]
                                                            .description,
                                                        maxLines: null,
                                                        softWrap: true,
                                                        style: context
                                                            .textTheme.bodyText2
                                                            .copyWith(
                                                          color: kDarkColor,
                                                          fontSize: 14,
                                                        )),
                                                  ),
                                                ],
                                              ).pOnly(bottom: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      disputesState
                                                          .disputes[index]
                                                          .orderDetails
                                                          .items[itemsIndex]
                                                          .total,
                                                      style: context
                                                          .textTheme.bodyText2
                                                          .copyWith(
                                                        color:
                                                            kPrimaryLightTextColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      )),
                                                  Text(
                                                      " * ${disputesState.disputes[index].orderDetails.items[itemsIndex].quantity}",
                                                      style: context
                                                          .textTheme.bodyText2
                                                          .copyWith(
                                                        color: kDarkColor
                                                            .withOpacity(0.50),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).py(5);
                                  },
                                ).pOnly(bottom: 10),
                                Text(
                                  "Total Amount : ${disputesState.disputes[index].orderDetails.grandTotal}"
                                      .toUpperCase(),
                                  textAlign: TextAlign.end,
                                  style: context.textTheme.bodyText2.copyWith(
                                      color: kPriceColor,
                                      fontWeight: FontWeight.bold),
                                ).pOnly(bottom: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Wrap(
                                        spacing: 5.0,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text("Contact Seller",
                                                style: context
                                                    .textTheme.overline
                                                    .copyWith(
                                                        color:
                                                            kPrimaryLightTextColor)),
                                          ).onInkTap(() async {
                                            context.nextPage(VendorChatScreen(
                                                shopId: disputesState
                                                    .disputes[index].shop.id,
                                                shopImage: disputesState
                                                    .disputes[index].shop.image,
                                                shopName: disputesState
                                                    .disputes[index].shop.name,
                                                shopVerifiedText: disputesState
                                                    .disputes[index]
                                                    .shop
                                                    .verifiedText));

                                            await context
                                                .read(productChatProvider)
                                                .productConversation(
                                                    disputesState
                                                        .disputes[index]
                                                        .shop
                                                        .id);
                                          }),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text("Dispute Details",
                                                style: context
                                                    .textTheme.overline
                                                    .copyWith(
                                                        color:
                                                            kPrimaryLightTextColor)),
                                          ).onInkTap(() {
                                            context
                                                .read(disputeDetailsProvider)
                                                .getDisputeDetails(disputesState
                                                    .disputes[index].id);
                                            context.nextPage(
                                                DisputeDetailsScreen());
                                          }),
                                          Visibility(
                                            visible: !disputesState
                                                .disputes[index].closed,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Text("Mark as Solved",
                                                  style: context
                                                      .textTheme.overline
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightTextColor)),
                                            ).onInkTap(() {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Close dispute"),
                                                      content:
                                                          Text("Are you sure?"),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("Yes"),
                                                          onPressed: () {
                                                            context
                                                                .read(
                                                                    disputesProvider)
                                                                .markAsSolved(
                                                                    disputesState
                                                                        .disputes[
                                                                            index]
                                                                        .id)
                                                                .then((value) =>
                                                                    context
                                                                        .pop());
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })
                    : Container(
                        child: LoadingWidget(),
                      ).center(),
      ),
    );
  }
}
