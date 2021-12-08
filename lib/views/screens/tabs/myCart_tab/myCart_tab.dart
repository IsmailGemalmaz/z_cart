import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/models/cart/cart_model.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/screens/product_details/product_details_screen.dart';
import 'package:zcart/views/screens/tabs/myCart_tab/checkout/checkout_screen.dart';
import 'package:zcart/views/shared_widgets/product_loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

class MyCartTab extends StatefulWidget {
  @override
  _MyCartTabState createState() => _MyCartTabState();
}

class _MyCartTabState extends State<MyCartTab> {
  @override
  Widget build(BuildContext context) {
    return ProviderListener<CheckoutState>(
        provider: checkoutNotifierProvider.state,
        onChange: (context, state) {
          if (state is CheckoutLoadedState) {
            context.read(cartNotifierProvider).getCartList();
            if (accessAllowed) context.read(ordersProvider).orders();
          }
        },
        child: Consumer(builder: (context, watch, _) {
          final cartState = watch(cartNotifierProvider.state);

          return Scaffold(
              appBar: AppBar(
                title: Text("My Cart"),
                centerTitle: true,
                elevation: 0,
                actions: [
                  (cartState is CartErrorState || cartState is CartLoadingState)
                      ? Icon(Icons.refresh).pOnly(right: 10).onInkTap(() {
                          context.read(cartNotifierProvider).getCartList();
                        })
                      : Container(),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: cartState is CartLoadedState
                        ? cartState.cartList.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.info_outline),
                                    Text("No items added yet!")
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: cartState.cartList.length,
                                padding: EdgeInsets.only(top: 5),
                                itemBuilder: (context, index) {
                                  return CartItemCard(
                                      cartItem: cartState.cartList[index]);
                                })
                        : ProductLoadingWidget().px(10),
                  ),
                ],
              ));
        }));
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({@required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kLightColor, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cartItem.shop.name,
                  style: context.textTheme.headline6
                      .copyWith(color: kPrimaryColor))
              .pOnly(bottom: 10),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartItem.items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ItemCard(
                            cartID: cartItem.id,
                            cartItem: cartItem.items[index])
                        .onInkTap(() {
                      context
                          .read(productNotifierProvider)
                          .getProductDetails(cartItem.items[index].slug);
                      context
                          .read(productSlugListProvider)
                          .addProductSlug(cartItem.items[index].slug);
                      context.nextPage(ProductDetailsScreen());
                    }),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kCardBgColor),
                    )
                        .pOnly(bottom: 8)
                        .visible(cartItem.items.length != 1)
                        .visible(index != cartItem.items.length - 1),
                  ],
                );
              }).pOnly(bottom: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.grandTotal,
                      style: context.textTheme.bodyText2.copyWith(
                          color: kPriceColor, fontWeight: FontWeight.bold)),
                  Text("Grand Total", style: context.textTheme.bodyText2),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    if (accessAllowed) {
                      context.read(addressNotifierProvider).fetchAddress();
                    }
                    context.read(shippingNotifierProvider).fetchShippingInfo(
                        cartItem.shop.id, cartItem.shippingZoneId);
                    context
                        .read(packagingNotifierProvider)
                        .fetchPackagingInfo(cartItem.shop.slug);
                    context
                        .read(paymentOptionsNotifierProvider)
                        .fetchPaymentMethod(cartItem.shop.slug);
                    context
                        .read(cartItemDetailsNotifierProvider)
                        .getCartItemDetails(cartItem.id);
                    context.read(countryNotifierProvider).getCountries();
                    context.nextPage(CheckoutScreen());
                  },
                  child: Text("Checkout"))
            ],
          )
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({@required this.cartItem, @required this.cartID});

  final int cartID;
  final Item cartItem;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            widget.cartItem.image,
            height: 50,
            width: 50,
            errorBuilder: (BuildContext _, Object error, StackTrace stack) {
              return Container();
            },
          ).px(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(widget.cartItem.description,
                              maxLines: null,
                              softWrap: true,
                              style: context.textTheme.subtitle2
                                  .copyWith(color: kDarkColor))
                          .pOnly(right: 10),
                    ),
                    Text(
                      widget.cartItem.unitPrice,
                      style: context.textTheme.bodyText2.copyWith(
                          color: kPriceColor, fontWeight: FontWeight.bold),
                    ).pOnly(right: 5),
                  ],
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  buttonPadding: EdgeInsets.symmetric(horizontal: 5),
                  buttonMinWidth:
                      30, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    OutlinedButton(
                        child: Icon(Icons.remove),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kLightBgColor),
                          foregroundColor:
                              MaterialStateProperty.all(kPrimaryDarkTextColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: widget.cartItem.quantity == 1
                            ? () {
                                showConfirmDialog(context,
                                    "Do you want to delete this item from the cart?",
                                    buttonColor: kPrimaryColor, onAccept: () {
                                  context
                                      .read(cartNotifierProvider)
                                      .removeFromCart(
                                        widget.cartID,
                                        widget.cartItem.id,
                                      );
                                });
                              }
                            : () {
                                toast('Please wait');
                                setState(() {
                                  widget.cartItem.quantity--;
                                });
                                context.read(cartNotifierProvider).updateCart(
                                    widget.cartID,
                                    listingID: widget.cartItem.id,
                                    quantity: widget.cartItem.quantity);
                              }),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        widget.cartItem.quantity.toString(),
                        style: context.textTheme.subtitle2,
                      ),
                    ),
                    OutlinedButton(
                        child: Icon(Icons.add),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kLightBgColor),
                            foregroundColor: MaterialStateProperty.all(
                                kPrimaryDarkTextColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          toast('Please wait');
                          setState(() {
                            widget.cartItem.quantity++;
                          });
                          context.read(cartNotifierProvider).updateCart(
                                widget.cartID,
                                listingID: widget.cartItem.id,
                                quantity: widget.cartItem.quantity,
                              );
                        }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            toast('Please wait');
            context.read(cartNotifierProvider).removeFromCart(
                  widget.cartID,
                  widget.cartItem.id,
                );
          },
        ),
      ],
    );
  }
}
