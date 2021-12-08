import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/order_provider.dart';
import 'package:zcart/riverpod/providers/product_provider.dart';
import 'package:zcart/riverpod/providers/product_slug_list_provider.dart';
import 'package:zcart/riverpod/state/order_state.dart';
import 'package:zcart/views/screens/product_details/product_details_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/disputes/dispute_details_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/disputes/open_dispute_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/orders/feedback_screen.dart';
import 'package:zcart/views/shared_widgets/custom_button.dart';
import 'package:zcart/views/shared_widgets/loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

class OrderDetailsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final orderDetailsState = watch(orderProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,
      ),
      body: orderDetailsState is OrderLoadedState
          ? SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        color: kLightColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                buttonText:
                                    orderDetailsState.orderDetails.orderStatus,
                                buttonBGColor: orderDetailsState
                                            .orderDetails.orderStatus ==
                                        "DELIVERED"
                                    ? kGreenColor
                                    : kPrimaryColor,
                                widthMultiplier: 1,
                              ),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Order Number: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.orderNumber,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex: 2, child: Text("Date: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.orderDate,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Order Status: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.orderStatus,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Shipping Address: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.shippingAddress,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Billing Address: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.billingAddress,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Shipping Cost: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.shipping,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Packaging Cost: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                      .orderDetails.packaging ??
                                                  '0',
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Shipping Weight: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.shippingWeight,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  orderDetailsState
                                              .orderDetails.messageToCustomer !=
                                          null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                    "Message To Customer: ")),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                    orderDetailsState
                                                        .orderDetails
                                                        .messageToCustomer,
                                                    style: context
                                                        .textTheme.subtitle2)),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ).cornerRadius(10),
                      Container(
                        color: kLightColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  orderDetailsState.orderDetails.shop.image,
                                  errorBuilder: (BuildContext _, Object error,
                                      StackTrace stack) {
                                    return Container();
                                  },
                                  height: 50,
                                  width: 50,
                                ).p(10),
                                Text(
                                  orderDetailsState.orderDetails.shop.name,
                                  style: context.textTheme.headline6
                                      .copyWith(color: kDarkColor),
                                ),
                                orderDetailsState.orderDetails.shop.verified
                                    ? Icon(Icons.check_circle,
                                            color: kPrimaryColor, size: 15)
                                        .px2()
                                        .pOnly(top: 3)
                                        .onInkTap(() {
                                        toast(orderDetailsState
                                            .orderDetails.shop.verifiedText);
                                      })
                                    : Container()
                              ],
                            ),
                            Divider(),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    orderDetailsState.orderDetails.items.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      context
                                          .read(productNotifierProvider)
                                          .getProductDetails(orderDetailsState
                                              .orderDetails.items[index].slug);
                                      context
                                          .read(productSlugListProvider)
                                          .addProductSlug(orderDetailsState
                                              .orderDetails.items[index].slug);
                                      context.nextPage(ProductDetailsScreen());
                                    },
                                    leading: Image.network(
                                      orderDetailsState
                                          .orderDetails.items[index].image,
                                      errorBuilder: (BuildContext _,
                                          Object error, StackTrace stack) {
                                        return Container();
                                      },
                                    ),
                                    title: Text(orderDetailsState
                                        .orderDetails.items[index].description),
                                    subtitle: Text(
                                      orderDetailsState
                                          .orderDetails.items[index].unitPrice,
                                      style: context.textTheme.subtitle2
                                          .copyWith(color: kPrimaryColor),
                                    ),
                                    trailing: Text('x ' +
                                        orderDetailsState
                                            .orderDetails.items[index].quantity
                                            .toString()),
                                  );
                                })
                          ],
                        ),
                      ).cornerRadius(10).py(10),
                      Container(
                        color: kLightColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\nPayment Details\n',
                                  style: context.textTheme.subtitle2),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex: 2, child: Text("Total: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.total,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex: 2, child: Text("Taxes: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                      .orderDetails.taxes ??
                                                  '0',
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2, child: Text("Shipping: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.shipping,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Payment Method: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState.orderDetails
                                                  .paymentMethod.name,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Payment Status: ")),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              orderDetailsState
                                                  .orderDetails.paymentStatus,
                                              style:
                                                  context.textTheme.subtitle2)),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Net Total: ' +
                                            orderDetailsState
                                                .orderDetails.total,
                                        style: context.textTheme.subtitle2
                                            .copyWith(color: kPrimaryColor),
                                      )
                                    ],
                                  ).pOnly(bottom: 10),
                                  _orderDetailsFooter(
                                      context, orderDetailsState),
                                ],
                              )
                            ],
                          ),
                        ),
                      ).cornerRadius(10),
                    ],
                  )),
            )
          : LoadingWidget(),
    );
  }

  Row _orderDetailsFooter(
      BuildContext context, OrderLoadedState orderDetailsState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Wrap(
            spacing: 3,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Feedback",
                  style: TextStyle(fontSize: 12, color: kLightColor),
                ).pSymmetric(h: 8, v: 8),
              )
                  .visible(
                orderDetailsState.orderDetails.orderStatus == "DELIVERED",
              )
                  .onInkTap(() {
                if (orderDetailsState.orderDetails.canEvaluate)
                  context.nextPage(FeedbackScreen(
                    order: orderDetailsState.orderDetails,
                  ));
                else
                  toast('Feedback already given');
              }),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Open Dispute",
                  style: TextStyle(fontSize: 12, color: kLightColor),
                ).pSymmetric(h: 8, v: 8),
              )
                  .visible(
                orderDetailsState.orderDetails.disputeId == null,
              )
                  .onInkTap(() {
                context
                    .read(disputeInfoProvider)
                    .getDisputeInfo(orderDetailsState.orderDetails.id);
                context.nextPage(OpenDisputeScreen());
              }),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Dispute Details",
                  style: TextStyle(fontSize: 12, color: kLightColor),
                ).pSymmetric(h: 8, v: 8),
              )
                  .visible(
                orderDetailsState.orderDetails.disputeId != null,
              )
                  .onInkTap(() {
                context.read(disputeDetailsProvider).getDisputeDetails(
                    orderDetailsState.orderDetails.disputeId);
                context.nextPage(DisputeDetailsScreen());
              }),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Confirm Received",
                  style: TextStyle(fontSize: 12, color: kLightColor),
                ).pSymmetric(h: 8, v: 8),
              )
                  .visible(
                orderDetailsState.orderDetails.orderStatus == "DELIVERED"
                    ? false
                    : true,
              )
                  .onInkTap(() {
                if (orderDetailsState.orderDetails.orderStatus != "DELIVERED")
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Received product"),
                          content: Text("Are you sure?"),
                          actions: [
                            TextButton(
                              child: Text(
                                "No",
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              onPressed: () {
                                context.pop();
                              },
                            ),
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                context
                                    .read(orderReceivedProvider)
                                    .orderReceived(
                                        orderDetailsState.orderDetails.id)
                                    .then((value) => context
                                        .read(ordersProvider)
                                        .orders(ignoreLoadingState: true))
                                    .then((value) => context.pop());
                              },
                            ),
                          ],
                        );
                      });
              }),
            ],
          ),
        )
      ],
    );
  }
}
