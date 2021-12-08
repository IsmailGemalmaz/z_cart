import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:zcart/riverpod/providers/product_provider.dart';
import 'package:zcart/riverpod/providers/product_slug_list_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/providers/wishlist_provider.dart';
import 'package:zcart/riverpod/state/scroll_state.dart';
import 'package:zcart/riverpod/state/wishlist_state.dart';
import 'package:zcart/views/screens/product_details/product_details_screen.dart';
import 'package:zcart/views/shared_widgets/product_loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:nb_utils/nb_utils.dart';

class WishListTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final wishListState = watch(wishListNotifierProvider.state);
    final scrollControllerProvider = watch(wishlistScrollNotifierProvider);

    return ProviderListener<ScrollState>(
        onChange: (context, state) {
          if (state is ScrollReachedBottomState) {
            context.read(wishListNotifierProvider).getMoreWishList();
          }
        },
        provider: wishlistScrollNotifierProvider.state,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Wishlist"),
              centerTitle: true,
              elevation: 0,
            ),
            body: wishListState is WishListLoadedState
                ? wishListState.wishList.length == 0
                    ? Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline),
                              Text("No items added yet!")
                            ]),
                      )
                    : ListView.builder(
                        controller: scrollControllerProvider.controller,
                        itemCount: wishListState.wishList.length,
                        padding: EdgeInsets.only(top: 5),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: kLightColor,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: EdgeInsets.all(5),
                            child: Slidable(
                              actionPane: SlidableStrechActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      wishListState.wishList[index].image,
                                      errorBuilder: (BuildContext _,
                                          Object error, StackTrace stack) {
                                        return Container();
                                      },
                                      height: 50,
                                      width: 50,
                                    ).p(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("Staff Pick",
                                                    style: context
                                                        .textTheme.overline
                                                        .copyWith(
                                                            color:
                                                                kPrimaryLightTextColor)),
                                              ).pOnly(right: 3).visible(
                                                  wishListState.wishList[index]
                                                          .stuffPick ??
                                                      false),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("Hot Item",
                                                    style: context
                                                        .textTheme.overline
                                                        .copyWith(
                                                            color:
                                                                kPrimaryLightTextColor)),
                                              ).pOnly(right: 3).visible(
                                                  wishListState.wishList[index]
                                                          .hotItem ??
                                                      false),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("Free Shipping",
                                                    style: context
                                                        .textTheme.overline
                                                        .copyWith(
                                                            color:
                                                                kPrimaryLightTextColor)),
                                              ).pOnly(right: 3).visible(
                                                  wishListState.wishList[index]
                                                          .freeShipping ??
                                                      false),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("New",
                                                    style: context
                                                        .textTheme.overline
                                                        .copyWith(
                                                            color:
                                                                kPrimaryLightTextColor)),
                                              ).pOnly(right: 3).visible(
                                                  wishListState.wishList[index]
                                                          .condition ==
                                                      "New"),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text(
                                                    wishListState
                                                        .wishList[index]
                                                        .discount,
                                                    style: context
                                                        .textTheme.overline
                                                        .copyWith(
                                                            color:
                                                                kPrimaryLightTextColor)),
                                              ).pOnly(right: 3).visible(
                                                  wishListState.wishList[index]
                                                          .hasOffer ??
                                                      false),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  wishListState
                                                      .wishList[index].title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: context
                                                      .textTheme.bodyText2
                                                      .copyWith(
                                                    color: kDarkColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ).pOnly(bottom: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                  wishListState.wishList[index]
                                                          .hasOffer
                                                      ? wishListState
                                                          .wishList[index]
                                                          .offerPrice
                                                      : wishListState
                                                          .wishList[index]
                                                          .price,
                                                  style: context
                                                      .textTheme.bodyText2
                                                      .copyWith(
                                                          color: kPriceColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              wishListState
                                                      .wishList[index].hasOffer
                                                  ? Text(
                                                      wishListState
                                                          .wishList[index]
                                                          .price,
                                                      style: context
                                                          .textTheme.caption
                                                          .copyWith(
                                                        color:
                                                            kPrimaryFadeTextColor,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      )).pOnly(left: 3)
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(CupertinoIcons.cart_badge_plus).p(10)
                                  ],
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    toast('Please wait');
                                    context
                                        .read(wishListNotifierProvider)
                                        .removeFromWishList(
                                            wishListState.wishList[index].id);
                                  },
                                ),
                              ],
                            ),
                          ).onInkTap(() {
                            context
                                .read(productNotifierProvider)
                                .getProductDetails(
                                    wishListState.wishList[index].slug);
                            context
                                .read(productSlugListProvider)
                                .addProductSlug(
                                    wishListState.wishList[index].slug);
                            context.nextPage(ProductDetailsScreen());
                          });
                        })
                : ProductLoadingWidget().px(10)));
  }
}
