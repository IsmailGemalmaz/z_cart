import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/dispute/dispute_info_state.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:nb_utils/nb_utils.dart';

class OpenDisputeScreen extends StatefulWidget {
  @override
  _OpenDisputeScreenState createState() => _OpenDisputeScreenState();
}

class _OpenDisputeScreenState extends State<OpenDisputeScreen> {
  bool showItemsDropdownField = false;
  bool selected = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController disputeReasonController = TextEditingController();
  final TextEditingController goodsReceivedConfirmationController =
      TextEditingController();
  final TextEditingController refundAmountController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open a Dispute"),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          final disputeInfoState = watch(disputeInfoProvider.state);
          return disputeInfoState is DisputeInfoLoadedState
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// Order details
                          Container(
                            color: kLightColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\nOrder Details\n',
                                      style: context.textTheme.subtitle2),
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
                                                  disputeInfoState
                                                      .disputeInfo.orderNumber,
                                                  style: context
                                                      .textTheme.subtitle2)),
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
                                                  disputeInfoState
                                                      .disputeInfo.orderStatus,
                                                  style: context
                                                      .textTheme.subtitle2)),
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
                                              child: Text("Amount paid: ")),
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                  disputeInfoState
                                                      .disputeInfo.total,
                                                  style: context
                                                      .textTheme.subtitle2)),
                                        ],
                                      ),
                                      const SizedBox(height: 9),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ).cornerRadius(10).pOnly(bottom: 10),

                          /// Open dispute
                          Container(
                            color: kLightColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\nOpen Dispute\n',
                                      style: context.textTheme.subtitle2),
                                  CustomDropDownField(
                                    title: "Select dispute reason",
                                    optionsList: disputeInfoState
                                        .disputeInfo.disputeType.values
                                        .toList(),
                                    value: "Select",
                                    isCallback: true,
                                    controller: disputeReasonController,
                                    widthMultiplier: 1,
                                    callbackFunction: (int disputeValueIndex) {
                                      context
                                              .read(openDisputeInfoProvider)
                                              .disputeType =
                                          disputeInfoState
                                              .disputeInfo.disputeType.keys
                                              .toList()[disputeValueIndex];
                                    },
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Dispute reason can\'t be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomDropDownField(
                                    title: "Have you received good(s)?",
                                    optionsList: [
                                      "No",
                                      "Yes",
                                    ],
                                    value: "Select",
                                    controller:
                                        goodsReceivedConfirmationController,
                                    isCallback: true,
                                    widthMultiplier: 1,
                                    callbackFunction: (id) {
                                      /* NO - 0, YES - 1*/
                                      setState(() {
                                        showItemsDropdownField = (id == 1);
                                        context
                                            .read(openDisputeInfoProvider)
                                            .orderReceived = id.toString();
                                        if (!showItemsDropdownField)
                                          selected = false;
                                      });
                                    },
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Field can\'t be empty';
                                      }

                                      return null;
                                    },
                                  ),
                                  Visibility(
                                    visible: showItemsDropdownField,
                                    child: CustomDropDownField(
                                      title: "Select product",
                                      optionsList: disputeInfoState
                                          .disputeInfo.items.values
                                          .toList(),
                                      value: "Select",
                                      controller: productController,
                                      widthMultiplier: 1,
                                      isCallback: true,
                                      callbackFunction:
                                          (int productValueIndex) {
                                        context
                                                .read(openDisputeInfoProvider)
                                                .productId =
                                            disputeInfoState
                                                .disputeInfo.items.keys
                                                .toList()[productValueIndex];
                                      },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please select product';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                      visible: showItemsDropdownField,
                                      child: ListTile(
                                        dense: true,
                                        minLeadingWidth: 0,
                                        horizontalTitleGap: 5,
                                        contentPadding: EdgeInsets.zero,
                                        leading: selected
                                            ? Icon(
                                                Icons.check_circle,
                                                color: kPrimaryColor,
                                              )
                                            : Icon(
                                                Icons.radio_button_unchecked),
                                        onTap: () {
                                          setState(() {
                                            selected = !selected;
                                          });
                                          /* NO - 0, YES - 1*/
                                          if (showItemsDropdownField)
                                            context
                                                .read(openDisputeInfoProvider)
                                                .returnGoods = selected ==
                                                    true
                                                ? '1'
                                                : '0';
                                        },
                                        title: Text("Return good(s)"),
                                      )),
                                  Visibility(
                                      visible: selected,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          "If the seller accepts your proposal, you will be asked to return the item(s) you have received and provider a return tracking number.",
                                          style: context.textTheme.subtitle2
                                              .copyWith(color: kPrimaryColor),
                                        ),
                                      )),
                                  CustomTextField(
                                    color: kCardBgColor,
                                    title: "Refund amount",
                                    hintText: "Refund amount",
                                    controller: refundAmountController,
                                    widthMultiplier: 1,
                                    validator: (value) {
                                      if (value
                                          .toString()
                                          .isNotBlank) if (double.parse(
                                              value) >
                                          double.parse(disputeInfoState
                                              .disputeInfo.totalRaw
                                              .split('\$')
                                              .last)) {
                                        return 'Must be equal to or less than total(${disputeInfoState.disputeInfo.totalRaw}) amount!';
                                      }
                                      context
                                          .read(openDisputeInfoProvider)
                                          .refundAmount = value;
                                      return null;
                                    },
                                  ),
                                  CustomTextField(
                                    color: kCardBgColor,
                                    title: "Description",
                                    hintText: "Description",
                                    controller: descriptionController,
                                    widthMultiplier: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter description';
                                      }
                                      context
                                          .read(openDisputeInfoProvider)
                                          .description = value;
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              toast("Please wait");
                                              context
                                                  .read(openDisputeInfoProvider)
                                                  .getOpenDispute(
                                                      disputeInfoState
                                                          .disputeInfo.id)
                                                  .then((value) {
                                                toast("Opened a dispute");
                                                context
                                                    .read(disputesProvider)
                                                    .getDisputes();
                                                context
                                                    .read(ordersProvider)
                                                    .orders(
                                                        ignoreLoadingState:
                                                            true);
                                                context.pop();
                                              });
                                            }
                                          },
                                          child: Text("Open a Dispute")),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).cornerRadius(10).pOnly(bottom: 10),

                          /// How to open a dispute
                          Container(
                            color: kLightColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\nHow to Open a Dispute\n',
                                      style: context.textTheme.subtitle2),
                                  Text('First Step:',
                                      style: context.textTheme.subtitle2),
                                  Text(
                                    'Before opening a dispute, we recommend you to contact the seller to discuss about the issue. Most of the case seller will help to solve the issue.\n',
                                    style: context.textTheme.subtitle2,
                                  ),
                                  Text('Second Step:',
                                      style: context.textTheme.subtitle2),
                                  Text(
                                    '''You can choose between two options:\n\nRefund Only – this means that either you did not receive the item and you’re applying for a full refund or you did receive the item and you want a partial refund (without having to send the item back), OR\n\nReturn Goods – this means that you want to return the item and apply for a full refund.\n''',
                                    style: context.textTheme.subtitle2,
                                  ),
                                  Text('Third Step:',
                                      style: context.textTheme.subtitle2),
                                  Text(
                                    'If you and seller can\'t come to an agreement, you can appeal the dispute to review. This point we will step in and help.\n',
                                    style: context.textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          ).cornerRadius(10),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(child: LoadingWidget().center()).center();
        },
      ),
    );
  }
}
