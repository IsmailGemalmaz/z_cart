import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/data/controller/chat/chat_controller.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/order_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/order_state.dart';
import 'package:zcart/views/screens/product_details/product_details_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/disputes/open_dispute_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/messages/order_chat_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/orders/order_details_screen.dart';
import 'package:zcart/Theme/styles/colors.dart';

class MyOrderScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ordersState = watch(ordersProvider.state);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("My Orders"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ordersState is OrdersLoadedState
            ? RefreshIndicator(
                onRefresh: () => context
                    .read(ordersProvider)
                    .orders(ignoreLoadingState: true),
                child: ListView.builder(
                    itemCount: ordersState.orders.length,
                    itemBuilder: (context, orderIndex) {
                      return OrderCard(
                          orderListState: ordersState, orderIndex: orderIndex);
                    }),
              )
            : Container(),
      ),
    );
  }
}

/* WIDGET */
class OrderCard extends StatelessWidget {
  const OrderCard({Key key, @required this.orderListState, this.orderIndex})
      : super(key: key);

  final OrdersLoadedState orderListState;
  final int orderIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: kLightColor, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            orderListState.orders[orderIndex].shop.image,
                            errorBuilder: (BuildContext _, Object error,
                                StackTrace stack) {
                              return Container();
                            },
                            fit: BoxFit.contain,
                          ).pOnly(left: 10),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderListState.orders[orderIndex].shop.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: double.parse(
                                orderListState.orders[orderIndex].shop.rating ??
                                    '0.0'),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemSize: 12,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) =>
                                Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) => print(rating),
                          ).pOnly(top: 5)
                        ],
                      ).pOnly(left: 10),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: orderListState.orders[orderIndex].orderStatus !=
                                "DELIVERED"
                            ? kPrimaryColor
                            : Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(orderListState.orders[orderIndex].orderStatus,
                        style: context.textTheme.overline
                            .copyWith(color: kPrimaryLightTextColor)),
                  ),
                ],
              ),
              Container(
                height: 60,
                child: ListView.builder(
                    itemCount: orderListState.orders[orderIndex].items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, itemsIndex) {
                      return Image.network(
                        orderListState
                            .orders[orderIndex].items[itemsIndex].image,
                        errorBuilder:
                            (BuildContext _, Object error, StackTrace stack) {
                          return Container();
                        },
                        height: 50,
                        width: 50,
                      ).p(10).onInkTap(() {
                        context.read(productNotifierProvider).getProductDetails(
                            orderListState
                                .orders[orderIndex].items[itemsIndex].slug);
                        context.read(productSlugListProvider).addProductSlug(
                            orderListState
                                .orders[orderIndex].items[itemsIndex].slug);
                        context.nextPage(ProductDetailsScreen());
                      });
                    }),
              ),
              Text(
                "Order Number : ${orderListState.orders[orderIndex].orderNumber}",
                style: context.textTheme.overline.copyWith(fontSize: 11),
              ).pOnly(top: 10),
              Text(
                "Ordered at : ${orderListState.orders[orderIndex].orderDate}",
                style: context.textTheme.overline.copyWith(fontSize: 11),
              ).pOnly(bottom: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Wrap(
                      //runSpacing: 5.0,
                      spacing: 10.0,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Contact Seller",
                            style: TextStyle(fontSize: 12, color: kLightColor),
                          ),
                        ).onInkTap(() {
                          context.read(orderChatProvider).orderConversation(
                              orderListState.orders[orderIndex].id);
                          context.nextPage(OrderChatScreen(
                              orders: orderListState.orders[orderIndex]));
                        }),
                        Container(
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Details",
                            style: TextStyle(fontSize: 12, color: kLightColor),
                          ),
                        ).onInkTap(() {
                          context.read(orderProvider).getOrderDetails(
                              orderListState.orders[orderIndex].id);
                          context.nextPage(OrderDetailsScreen());
                        }),
                        Visibility(
                          visible:
                              orderListState.orders[orderIndex].disputeId ==
                                  null,
                          child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Open a dispute",
                              style:
                                  TextStyle(fontSize: 12, color: kLightColor),
                            ),
                          ).onInkTap(() {
                            context.read(disputeInfoProvider).getDisputeInfo(
                                orderListState.orders[orderIndex].id);
                            context.nextPage(OpenDisputeScreen());
                          }),
                        ),
                        Visibility(
                          visible:
                              orderListState.orders[orderIndex].orderStatus !=
                                  "DELIVERED",
                          child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              orderListState.orders[orderIndex].orderStatus ==
                                      "DELIVERED"
                                  ? ""
                                  : "Confirm Received",
                              style:
                                  TextStyle(fontSize: 12, color: kLightColor),
                            ),
                          ).onInkTap(() {
                            if (orderListState.orders[orderIndex].orderStatus !=
                                "DELIVERED")
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Received product"),
                                      content: Text("Are you sure?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            context
                                                .read(orderReceivedProvider)
                                                .orderReceived(orderListState
                                                    .orders[orderIndex].id)
                                                .then((value) => context
                                                    .read(ordersProvider)
                                                    .orders(
                                                        ignoreLoadingState:
                                                            true))
                                                .then((value) => context.pop());
                                          },
                                        )
                                      ],
                                    );
                                  });

                            // if (orderListState.orders[orderIndex].orderStatus ==
                            //     "DELIVERED") if (!orderListState.orders[orderIndex].canEvaluate)
                            //   context.nextPage(FeedbackScreen(
                            //     order: orderListState.orders[orderIndex],
                            //   ));
                            // else
                            //   toast('Feedback already given');
                          }),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(orderListState.orders[orderIndex].grandTotal,
                          style: context.textTheme.bodyText2.copyWith(
                              color: kPriceColor, fontWeight: FontWeight.bold)),
                      Text("Net Total", style: context.textTheme.overline)
                    ],
                  ).pOnly(left: 20)
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(50),
              ),
              color: kPrimaryColor,
            ),
            width: 35,
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 10),
              child: new Text(
                "${orderIndex + 1}",
                style: context.textTheme.overline.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: kLightColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
